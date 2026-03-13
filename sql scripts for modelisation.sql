CREATE TABLE dbo.Dim_Date (
    Date_ID         INT             NOT NULL,
    Full_Date       DATE            NOT NULL,
    Year            INT             NOT NULL,
    Quarter         NVARCHAR(5)     NOT NULL,
    Month_Number    INT             NOT NULL,
    Month_Name      NVARCHAR(20)    NOT NULL,
    Week_Number     INT             NOT NULL,
    Day_Name        NVARCHAR(20)    NOT NULL,
    Is_Weekend      BIT             NOT NULL,
    CONSTRAINT PK_Dim_Date PRIMARY KEY (Date_ID)
);

INSERT INTO dbo.Dim_Date (
    Date_ID, Full_Date, Year, Quarter,
    Month_Number, Month_Name, Week_Number,
    Day_Name, Is_Weekend
)
SELECT DISTINCT
    CAST(FORMAT(Sale_Date, 'yyyyMMdd') AS INT),
    Sale_Date,
    YEAR(Sale_Date),
    Quarter,
    MONTH(Sale_Date),
    Month,
    DATEPART(WEEK, Sale_Date),
    DATENAME(WEEKDAY, Sale_Date),
    CASE WHEN DATEPART(WEEKDAY, Sale_Date)
         IN (1,7) THEN 1 ELSE 0 END
FROM dbo.Staging_Sales
WHERE Sale_Date IS NOT NULL;

CREATE TABLE dbo.Dim_Product (
    Product_ID      INT             IDENTITY(1,1),
    Product_Name    NVARCHAR(200)   NOT NULL,
    Category        NVARCHAR(100)   NOT NULL,
    Storage         NVARCHAR(50)    NOT NULL,
    Color           NVARCHAR(50)    NOT NULL,
    Unit_Price_USD  DECIMAL(10,2)   NOT NULL,
    CONSTRAINT PK_Dim_Product PRIMARY KEY (Product_ID)
);

INSERT INTO dbo.Dim_Product (
    Product_Name, Category, Storage, Color, Unit_Price_USD
)
SELECT
    Product_Name,
    Category,
    Storage,
    Color,
    AVG(Unit_Price_USD) AS Unit_Price_USD
FROM dbo.Staging_Sales
WHERE Product_Name IS NOT NULL
GROUP BY Product_Name, Category, Storage, Color;

CREATE TABLE dbo.Dim_Geography (
    Geography_ID    INT             IDENTITY(1,1),
    City            NVARCHAR(100)   NOT NULL,
    Country         NVARCHAR(100)   NOT NULL,
    Region          NVARCHAR(100)   NOT NULL,
    CONSTRAINT PK_Dim_Geography PRIMARY KEY (Geography_ID)
);

INSERT INTO dbo.Dim_Geography (City, Country, Region)
SELECT DISTINCT
    City,
    Country,
    Region
FROM dbo.Staging_Sales
WHERE Country IS NOT NULL;

CREATE TABLE dbo.Dim_Channel (
    Channel_ID      INT             IDENTITY(1,1),
    Channel_Name    NVARCHAR(100)   NOT NULL,
    CONSTRAINT PK_Dim_Channel PRIMARY KEY (Channel_ID)
);

INSERT INTO dbo.Dim_Channel (Channel_Name)
SELECT DISTINCT
    Sales_Channel
FROM dbo.Staging_Sales
WHERE Sales_Channel IS NOT NULL;


CREATE TABLE dbo.Dim_CustomerSegment (
    Segment_ID          INT             IDENTITY(1,1),
    Segment_Name        NVARCHAR(50)    NOT NULL,
    Age_Group           NVARCHAR(20)    NOT NULL,
    Payment_Method      NVARCHAR(50)    NOT NULL,
    Previous_Device_OS  NVARCHAR(50)    NOT NULL,
    CONSTRAINT PK_Dim_CustomerSegment PRIMARY KEY (Segment_ID)
);

INSERT INTO dbo.Dim_CustomerSegment (
    Segment_Name, Age_Group,
    Payment_Method, Previous_Device_OS
)
SELECT DISTINCT
    Customer_Segment,
    Customer_Age_Group,
    'Mixed'     AS Payment_Method,
    'Mixed'     AS Previous_Device_OS
FROM dbo.Staging_Sales
WHERE Customer_Segment IS NOT NULL
GROUP BY Customer_Segment, Customer_Age_Group;

CREATE TABLE dbo.Fact_Sales (
    Sales_ID                INT             IDENTITY(1,1),
    Date_ID                 INT             NOT NULL,
    Product_ID              INT             NOT NULL,
    Geography_ID            INT             NOT NULL,
    Channel_ID              INT             NOT NULL,
    Segment_ID              INT             NOT NULL,
    Sale_ID                 NVARCHAR(20)    NOT NULL,
    Units_Sold              INT             NOT NULL,
    Unit_Price_USD          DECIMAL(10,2)   NOT NULL,
    Discount_Pct            DECIMAL(5,2)    NOT NULL,
    Discounted_Price_USD    DECIMAL(10,2)   NOT NULL,
    Revenue_USD             DECIMAL(15,2)   NOT NULL,
    Currency                NVARCHAR(10)    NOT NULL,
    FX_Rate_To_USD          DECIMAL(10,4)   NOT NULL,
    Revenue_Local_Currency  DECIMAL(20,2)   NOT NULL,
    Customer_Rating         DECIMAL(3,1)    NULL,
    Return_Status           NVARCHAR(20)    NOT NULL,
    CONSTRAINT PK_Fact_Sales PRIMARY KEY (Sales_ID),
    CONSTRAINT FK_Fact_Date
        FOREIGN KEY (Date_ID)
        REFERENCES dbo.Dim_Date(Date_ID),
    CONSTRAINT FK_Fact_Product
        FOREIGN KEY (Product_ID)
        REFERENCES dbo.Dim_Product(Product_ID),
    CONSTRAINT FK_Fact_Geography
        FOREIGN KEY (Geography_ID)
        REFERENCES dbo.Dim_Geography(Geography_ID),
    CONSTRAINT FK_Fact_Channel
        FOREIGN KEY (Channel_ID)
        REFERENCES dbo.Dim_Channel(Channel_ID),
    CONSTRAINT FK_Fact_Segment
        FOREIGN KEY (Segment_ID)
        REFERENCES dbo.Dim_CustomerSegment(Segment_ID)
);

INSERT INTO dbo.Fact_Sales (
    Date_ID, Product_ID, Geography_ID,
    Channel_ID, Segment_ID, Sale_ID,
    Units_Sold, Unit_Price_USD, Discount_Pct,
    Discounted_Price_USD, Revenue_USD, Currency,
    FX_Rate_To_USD, Revenue_Local_Currency,
    Customer_Rating, Return_Status
)
SELECT
    CAST(FORMAT(s.Sale_Date, 'yyyyMMdd') AS INT),
    p.Product_ID,
    g.Geography_ID,
    c.Channel_ID,
    seg.Segment_ID,
    s.Sale_ID,
    s.Units_Sold,
    s.Unit_Price_USD,
    s.Discount_Pct,
    s.Discounted_Price_USD,
    s.Revenue_USD,
    s.Currency,
    s.FX_Rate_To_USD,
    s.Revenue_Local_Currency,
    s.Customer_Rating,
    s.Return_Status
FROM dbo.Staging_Sales s
JOIN dbo.Dim_Product p
    ON s.Product_Name = p.Product_Name
    AND s.Storage = p.Storage
    AND s.Color = p.Color
JOIN dbo.Dim_Geography g
    ON s.City = g.City
    AND s.Country = g.Country
JOIN dbo.Dim_Channel c
    ON s.Sales_Channel = c.Channel_Name
JOIN dbo.Dim_CustomerSegment seg
    ON s.Customer_Segment = seg.Segment_Name
    AND s.Customer_Age_Group = seg.Age_Group;

