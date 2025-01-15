use b4;
CREATE TABLE Diem (
    MaSV INT NOT NULL,                
    Diem DECIMAL(5,2) NOT NULL,       
    PRIMARY KEY (MaSV),        
    CHECK (Diem >= 0 AND Diem <= 10) 
);