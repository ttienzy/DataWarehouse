
USE [CinemaDataWarehouse];
GO

PRINT 'Expanding Data Warehouse with new Dimensions and Fact table...';

-- 1. TẠO CÁC BẢNG DIMENSION MỚI
CREATE TABLE [dbo].[Dim_Staff](
    [StaffKey] [int] IDENTITY(1,1) NOT NULL,
    [StaffSourceId] [int] NOT NULL,
    [EmployeeCode] [nvarchar](20) NOT NULL,
    [FullName] [nvarchar](100) NOT NULL,
    [Position] [nvarchar](100) NOT NULL,
    CONSTRAINT [PK_Dim_Staff] PRIMARY KEY CLUSTERED ([StaffKey] ASC)
);
GO

CREATE TABLE [dbo].[Dim_Inventory](
    [InventoryKey] [int] IDENTITY(1,1) NOT NULL,
    [InventorySourceId] [int] NOT NULL,
    [ItemName] [nvarchar](150) NOT NULL,
    [ItemCategory] [nvarchar](100) NOT NULL,
    CONSTRAINT [PK_Dim_Inventory] PRIMARY KEY CLUSTERED ([InventoryKey] ASC)
);
GO

-- 2. CẬP NHẬT DIM_CUSTOMER ĐỂ XỬ LÝ KHÁCH VÃNG LAI
SET IDENTITY_INSERT [dbo].[Dim_Customer] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[Dim_Customer] WHERE [CustomerKey] = 0)
BEGIN
    INSERT INTO [dbo].[Dim_Customer] ([CustomerKey], [CustomerSourceId], [FullName], [Gender], [City], [MembershipTier], [Age], [AgeGroup])
    VALUES (0, 0, 'Unknown Customer', 'N/A', 'N/A', 'N/A', 0, 'N/A');
END
SET IDENTITY_INSERT [dbo].[Dim_Customer] OFF;
GO

-- 3. TẠO BẢNG FACT THỨ HAI
CREATE TABLE [dbo].[Fact_ConcessionSale](
    [DateKey] [int] NOT NULL,
    [CinemaKey] [int] NOT NULL,
    [CustomerKey] [int] NOT NULL,
    [StaffKey] [int] NOT NULL,
    [InventoryKey] [int] NOT NULL,
    [SaleCode] [nvarchar](20) NULL,
    [QuantitySold] [int] NOT NULL,
    [UnitPrice] [decimal](18, 2) NOT NULL,
    [TotalPrice] [decimal](18, 2) NOT NULL,
    [DiscountAmount] [decimal](18, 2) NOT NULL,
    [FinalAmount] [decimal](18, 2) NOT NULL
);
GO

-- 4. THIẾT LẬP CÁC KHÓA NGOẠI
ALTER TABLE [dbo].[Fact_ConcessionSale] WITH CHECK ADD CONSTRAINT [FK_FactConcession_DimDate] FOREIGN KEY([DateKey]) REFERENCES [dbo].[Dim_Date] ([DateKey]);
GO
ALTER TABLE [dbo].[Fact_ConcessionSale] WITH CHECK ADD CONSTRAINT [FK_FactConcession_DimCinema] FOREIGN KEY([CinemaKey]) REFERENCES [dbo].[Dim_Cinema] ([CinemaKey]);
GO
ALTER TABLE [dbo].[Fact_ConcessionSale] WITH CHECK ADD CONSTRAINT [FK_FactConcession_DimCustomer] FOREIGN KEY([CustomerKey]) REFERENCES [dbo].[Dim_Customer] ([CustomerKey]);
GO
ALTER TABLE [dbo].[Fact_ConcessionSale] WITH CHECK ADD CONSTRAINT [FK_FactConcession_DimStaff] FOREIGN KEY([StaffKey]) REFERENCES [dbo].[Dim_Staff] ([StaffKey]);
GO
ALTER TABLE [dbo].[Fact_ConcessionSale] WITH CHECK ADD CONSTRAINT [FK_FactConcession_DimInventory] FOREIGN KEY([InventoryKey]) REFERENCES [dbo].[Dim_Inventory] ([InventoryKey]);
GO

PRINT 'Data Warehouse [CinemaDataWarehouse] is now ready for Concession Sales analysis.';
