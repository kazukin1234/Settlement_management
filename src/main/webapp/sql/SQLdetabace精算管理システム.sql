---これですべて管理--



DROP DATABASE IF EXISTS abc_system;
CREATE DATABASE abc_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE abc_system;

-- 部署マスタ
CREATE TABLE department_master (
    department_id VARCHAR(5) PRIMARY KEY,
    department_name VARCHAR(20) NOT NULL,
    delete_flag TINYINT DEFAULT 0 NOT NULL
);

INSERT INTO department_master (department_id, department_name, delete_flag) VALUES
('D0001', '営業部', 0),
('D0002', '管理部', 0),
('D0003','IT部',0);

-- 役職マスタ
CREATE TABLE position_master (
    position_id VARCHAR(5) PRIMARY KEY,
    position_name VARCHAR(20) NOT NULL,
    delete_flag TINYINT DEFAULT 0 NOT NULL
);

INSERT INTO position_master (position_id, position_name, delete_flag) VALUES
('P0001', '部長', 0),
('P0002', '主任', 0),
('P0003', '一般社員', 0);

-- 社員情報
CREATE TABLE staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(50) NOT NULL,
    furigana VARCHAR(50),
    birth_date DATE,
    address VARCHAR(255),
    hire_date DATE NOT NULL,
    department_id CHAR(5),
    position_id CHAR(5),
    delete_flag TINYINT DEFAULT 0,
    CONSTRAINT fk_staff_department FOREIGN KEY (department_id) REFERENCES department_master(department_id),
    CONSTRAINT fk_staff_position FOREIGN KEY (position_id) REFERENCES position_master(position_id)
);

INSERT INTO staff (
    staff_id, password, name, furigana, birth_date, address, hire_date, department_id, position_id, delete_flag
) VALUES
('S0001', 'pass123', '石井 和也', 'イシイ カズヤ', '1966-05-04', '愛知県岡崎市3丁目4-12', '2015-10-29', 'D0001', 'P0002', 0),
('S0002', 'pass123', '山田 太郎', 'ヤマダ タロウ', '2000-05-06', '大阪府大阪市', '2025-04-01', 'D0001', 'P0001', 0),
('S0003', 'pass123', '藤田 太郎', 'フジタ タロウ', '1995-09-06', '大阪府大阪市', '2020-04-01', 'D0003', 'P0003', 0),
('S0004', 'pass123', '佐藤 和也', 'サトウ カズヤ', '2002-03-28', '愛知県豊橋市3丁目9-9', '2024-06-30', 'D0003', 'P0001', 0),
('S1001', 'pass123', '石井 和也', 'イシイ カズヤ', '1966-05-04', '愛知県岡崎市3丁目4-12', '2015-10-29', 'D0002', 'P0003', 0),
('S9999', 'pass123', '石井 和也(管理部_部長)', 'イシイ カズヤ', '1966-05-04', '愛知県岡崎市3丁目4-12', '2015-10-29', 'D0002', 'P0001', 0);

-- プロジェクト管理（先に作成する）
CREATE TABLE project_manage (
    project_code VARCHAR(20) NOT NULL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    project_owner VARCHAR(50),
    start_date DATE,
    end_date DATE,
    delete_flag TINYINT(1) DEFAULT 0
);

INSERT INTO project_manage (
    project_code, project_name, project_owner, start_date, end_date
) VALUES
('PRJ001', '新商品開発', '田中太郎', '2025-01-10', '2025-06-30'),
('PRJ002', '社内システム刷新', '鈴木花子', '2025-02-01', '2025-12-31'),
('PRJ003', 'マーケティング調査', '佐藤次郎', '2025-03-15', '2025-09-30');

-- プロジェクト予算
CREATE TABLE project_budget (
    project_code VARCHAR(8) PRIMARY KEY,
    project_budget INT DEFAULT 0,
    project_actual INT DEFAULT 0,
    CONSTRAINT fk_pb_project FOREIGN KEY (project_code) REFERENCES project_manage(project_code) ON DELETE CASCADE
);

INSERT INTO project_budget (
    project_code, project_budget, project_actual
) VALUES
('PRJ001', 5000000, 3200000),
('PRJ002', 8000000, 4500000),
('PRJ003', 3000000, 2800000);

-- プロジェクト所属情報
CREATE TABLE project_member (
    staff_id VARCHAR(10) NOT NULL,
    project_code VARCHAR(8) NOT NULL,
    PRIMARY KEY (staff_id, project_code),
    CONSTRAINT fk_pm_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    CONSTRAINT fk_pm_project FOREIGN KEY (project_code) REFERENCES project_manage(project_code) ON DELETE CASCADE
);

INSERT INTO project_member (
    staff_id, project_code
) VALUES
('S0001', 'PRJ001'),
('S0002', 'PRJ001'),
('S0003', 'PRJ001'),
('S0001', 'PRJ002'),
('S0003', 'PRJ002'),
('S0004', 'PRJ002'),
('S0002', 'PRJ003');

-- 申請情報
CREATE TABLE application_header (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id VARCHAR(10) NOT NULL,
    approver_id VARCHAR(10),
    application_type VARCHAR(20) NOT NULL,
    amount INT DEFAULT 0 NOT NULL,
    status ENUM('未提出', '差戻し', '提出済み', '承認済み', '支払済み') DEFAULT '未提出',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    delete_flag TINYINT DEFAULT 0 NOT NULL,
    CONSTRAINT fk_app_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- 出張申請
CREATE TABLE business_trip_application (
    trip_application_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    project_code VARCHAR(20),
    report TEXT,
    total_days INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_bta_application FOREIGN KEY (application_id) REFERENCES application_header(application_id)
);

-- 出張手当明細
CREATE TABLE allowance_detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_application_id INT NOT NULL,
    region_type VARCHAR(50) NOT NULL,
    trip_type VARCHAR(50) NOT NULL,
    hotel VARCHAR(100) NOT NULL,
    burden VARCHAR(20) NOT NULL,
    hotel_fee INT NOT NULL DEFAULT 0,
    daily_allowance INT NOT NULL DEFAULT 0,
    days INT DEFAULT 0,
    expense_total INT DEFAULT 0,
    memo TEXT,
    adjustment_options VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_allowance_trip FOREIGN KEY (trip_application_id) REFERENCES business_trip_application(trip_application_id) ON DELETE CASCADE
);

-- 出張交通費明細
CREATE TABLE business_trip_transportation_detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_application_id INT NOT NULL,
    trans_project VARCHAR(50) NOT NULL,
    departure VARCHAR(100) NOT NULL,
    arrival VARCHAR(100) NOT NULL,
    transport VARCHAR(100) NOT NULL,
    fare_amount INT NOT NULL,
    trans_trip_type VARCHAR(50) NOT NULL,
    trans_burden VARCHAR(20) NOT NULL,
    trans_expense_total INT NOT NULL,
    trans_memo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_bttd_trip FOREIGN KEY (trip_application_id) REFERENCES business_trip_application(trip_application_id) ON DELETE CASCADE
);

-- 交通費申請
CREATE TABLE transportation_request (
    transportation_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    project_code VARCHAR(8),
    date DATE NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departure_station VARCHAR(10) NOT NULL,
    arrival_station VARCHAR(10) NOT NULL,
    category VARCHAR(5) DEFAULT '往復' NOT NULL,
    transport_type VARCHAR(8) NOT NULL,
    payer VARCHAR(20) NOT NULL,
    amount INT NOT NULL DEFAULT 0,
    abstract_note VARCHAR(225) NOT NULL,
    report VARCHAR(225),
    CONSTRAINT fk_tr_application FOREIGN KEY (application_id) REFERENCES application_header(application_id)
);

-- 立替精算
CREATE TABLE reimbursement_request (
    reimbursement_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    project_code VARCHAR(8) NOT NULL,
    date DATE NOT NULL,
    destinations VARCHAR(255),
    accounting_item VARCHAR(20),
    amount INT NOT NULL,
    abstract_note VARCHAR(225),
    report VARCHAR(225),
    CONSTRAINT fk_rr_application FOREIGN KEY (application_id) REFERENCES application_header(application_id)
);

-- 領収書ファイル
CREATE TABLE receipt_file (
    receipt_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    block_type ENUM('allowance_detail','business_trip_transportation_detail','reimbursement_request','transportation_request') NOT NULL,
    block_id INT NOT NULL,
    receipt_index INT NOT NULL,
    original_file_name VARCHAR(255) NOT NULL,
    stored_file_path VARCHAR(255) NOT NULL,
    uploaded_by VARCHAR(10) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_rf_application FOREIGN KEY (application_id) REFERENCES application_header(application_id) ON DELETE CASCADE
);
