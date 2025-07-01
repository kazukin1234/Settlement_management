package service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import bean.Project;
import bean.TransportationApplicationBean;
import bean.TransportationDetailBean;
import bean.UploadedFile;
import dao.ProjectListDAO;

@WebServlet("/transportationRequest")
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024,
	    maxFileSize = 10 * 1024 * 1024,
	    maxRequestSize = 50 * 1024 * 1024
	)
public class TransportationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // SỬA LỖI: Sử dụng thư mục temp_uploads nhất quán với code mẫu
    private static final String TEMP_UPLOAD_DIR = "/temp_uploads"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        TransportationApplicationBean transportationApp = (TransportationApplicationBean) session.getAttribute("transportationApp");

        if (transportationApp == null) {
            transportationApp = new TransportationApplicationBean();
            session.setAttribute("transportationApp", transportationApp);
        }
        
        try {
            ProjectListDAO projectDAO = new ProjectListDAO();
            List<ProjectListDAO.Project> daoProjectList = projectDAO.getAllProjects();
            List<Project> projectListForJsp = new ArrayList<>();
            for (ProjectListDAO.Project daoProject : daoProjectList) {
                Project jspProject = new Project(daoProject.getId(), daoProject.getName());
                projectListForJsp.add(jspProject);
            }
            request.setAttribute("projectList", projectListForJsp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("projectList", new ArrayList<Project>());
        }

        request.setAttribute("transportationApp", transportationApp);
        request.getRequestDispatcher("/WEB-INF/views/serviceJSP/transportation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("transportationApp") == null) {
            response.sendRedirect(request.getContextPath() + "/transportationInit");
            return;
        }

        TransportationApplicationBean transportationApp = (TransportationApplicationBean) session.getAttribute("transportationApp");

        // --- BẮT ĐẦU PHẦN SỬA LỖI LOGIC ---
        // Áp dụng hoàn toàn logic từ code ReimbursementServlet mẫu

        // 1. Xử lý các file được đánh dấu xóa
        String filesToDeleteParam = request.getParameter("filesToDelete");
        if (filesToDeleteParam != null && !filesToDeleteParam.trim().isEmpty()) {
            List<String> filesToDeleteList = Arrays.asList(filesToDeleteParam.split(","));
            String realPath = getServletContext().getRealPath("");
            for (TransportationDetailBean detail : transportationApp.getDetails()) {
                detail.getTemporaryFiles().removeIf(file -> {
                    boolean toDelete = filesToDeleteList.contains(file.getUniqueStoredName());
                    if (toDelete && file.getTemporaryPath() != null) {
                        try { Files.deleteIfExists(Paths.get(realPath + file.getTemporaryPath())); } catch (IOException e) { e.printStackTrace(); }
                    }
                    return toDelete;
                });
            }
        }

        // 2. Logic "Cập nhật tại chỗ"
        String[] projectCodes = request.getParameterValues("projectCode[]");
        List<TransportationDetailBean> detailsInSession = transportationApp.getDetails();
        int numSubmittedBlocks = (projectCodes != null) ? projectCodes.length : 0;
        List<TransportationDetailBean> updatedDetails = new ArrayList<>();

        // Lấy tất cả các mảng dữ liệu từ form
        String[] dates = request.getParameterValues("date[]");
        String[] destinations = request.getParameterValues("destination[]");
        String[] departures = request.getParameterValues("departure[]");
        String[] arrivals = request.getParameterValues("arrival[]");
        String[] transports = request.getParameterValues("transport[]");
        String[] fareAmounts = request.getParameterValues("fareAmount[]");
        String[] transTripTypes = request.getParameterValues("transTripType[]");
        String[] burdens = request.getParameterValues("burden[]");
        String[] expenseTotals = request.getParameterValues("expenseTotal[]");
        String[] reports = request.getParameterValues("report[]");
        String[] transMemos = request.getParameterValues("transMemo[]");

        for (int i = 0; i < numSubmittedBlocks; i++) {
            TransportationDetailBean detail;
            if (i < detailsInSession.size()) {
                detail = detailsInSession.get(i); // Dùng lại bean cũ
            } else {
                detail = new TransportationDetailBean(); // Tạo bean mới
            }

            // Cập nhật tất cả các trường
            detail.setProjectCode(projectCodes[i]);
            detail.setDate(dates[i]);
            detail.setDestination(destinations[i]);
            detail.setDeparture(departures[i]);
            detail.setArrival(arrivals[i]);
            detail.setTransport(transports[i]);
            detail.setTransTripType(transTripTypes[i]);
            detail.setBurden(burdens[i]);
            detail.setReport(reports[i]);
            detail.setTransMemo(transMemos[i]);
            
            try {
                detail.setFareAmount(fareAmounts[i] != null && !fareAmounts[i].isEmpty() ? Integer.parseInt(fareAmounts[i]) : 0);
//                detail.setExpenseTotal(expenseTotals[i] != null && !expenseTotals[i].isEmpty() ? Integer.parseInt(expenseTotals[i]) : 0);
                int multiplier = "往復".equals(detail.getTransTripType()) ? 2 : 1;
                if ("自己".equals(detail.getBurden())) {
                    detail.setExpenseTotal(detail.getFareAmount() * multiplier);
                } else {
                    detail.setExpenseTotal(0);
                }
            } catch (NumberFormatException e) {
                detail.setFareAmount(0);
                detail.setExpenseTotal(0);
            }
            updatedDetails.add(detail);
        }
        transportationApp.setDetails(updatedDetails);

        Collection<Part> allParts = request.getParts();
        long fileCount = allParts.stream()
        	    .filter(part -> part.getSubmittedFileName() != null && !part.getSubmittedFileName().isBlank())
        	    .count();

        	if (fileCount >100) {
        	    request.setAttribute("errorMessage", "ファイルの添付は最大100件までです。");
        	    request.getRequestDispatcher("/WEB-INF/views/serviceJSP/transportation.jsp").forward(request, response);
        	    return;
        	}
        for (int i = 0; i < numSubmittedBlocks; i++) {
            String fileInputName = "receipt_transportation_" + i;
            List<Part> newFileParts = allParts.stream()
                .filter(part -> fileInputName.equals(part.getName()) && part.getSize() > 0)
                .collect(Collectors.toList());

            if (!newFileParts.isEmpty()) {
                TransportationDetailBean detail = transportationApp.getDetails().get(i);
                // Xóa file cũ trong bean trước khi thêm file mới (quan trọng!)
                detail.getTemporaryFiles().clear(); 
                
                for (Part filePart : newFileParts) {
                    try {
                        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        if(originalFileName == null || originalFileName.isBlank()) continue;

                        String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                        String tempPath = getServletContext().getRealPath(TEMP_UPLOAD_DIR);
                        File uploadDir = new File(tempPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();
                        
                        Files.copy(filePart.getInputStream(), new File(uploadDir, uniqueFileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        
                        UploadedFile uf = new UploadedFile();
                        uf.setOriginalFileName(originalFileName);
                        uf.setUniqueStoredName(uniqueFileName);
                        uf.setTemporaryPath(TEMP_UPLOAD_DIR + "/" + uniqueFileName);
                        detail.getTemporaryFiles().add(uf);
                    } catch (Exception e) { e.printStackTrace(); }
                }
            }
        }
        
        // --- KẾT THÚC PHẦN SỬA LỖI LOGIC ---

        session.setAttribute("transportationApp", transportationApp);
        response.sendRedirect(request.getContextPath() + "/transportationConfirm");
    }
}