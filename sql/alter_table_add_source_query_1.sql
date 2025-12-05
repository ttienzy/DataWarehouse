
USE [CinemaDW];
GO

PRINT 'Creating missing operational tables in [CinemaDW]...';

-- Bảng quản lý sản phẩm bán kèm (bắp, nước...)
CREATE TABLE [dbo].[InventoryItems](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [CinemaId] [int] NOT NULL,
    [ItemName] [nvarchar](150) NOT NULL,
    [ItemCategory] [nvarchar](100) NOT NULL,
    [UnitPrice] [decimal](18,2) NOT NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    CONSTRAINT [PK_InventoryItems] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Bảng quản lý nhân viên
CREATE TABLE [dbo].[Staffs](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [CinemaId] [int] NOT NULL,
    [EmployeeCode] [nvarchar](20) NOT NULL,
    [FullName] [nvarchar](100) NOT NULL,
    [Position] [nvarchar](100) NOT NULL,
    [Department] [nvarchar](100) NULL,
    [Status] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Staffs] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_EmployeeCode] UNIQUE NONCLUSTERED ([EmployeeCode] ASC)
);
GO

-- Bảng chính ghi nhận giao dịch bán hàng phụ trợ
CREATE TABLE [dbo].[ConcessionSales](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [CinemaId] [int] NOT NULL,
    [CustomerId] [int] NULL, -- Cho phép NULL vì khách vãng lai không có ID
    [StaffId] [int] NOT NULL,
    [SaleCode] [nvarchar](20) NOT NULL,
    [SaleDate] [datetime2](7) NOT NULL DEFAULT GETDATE(),
    [TotalAmount] [decimal](18,2) NOT NULL,
    [DiscountAmount] [decimal](18,2) NULL DEFAULT 0,
    [FinalAmount] [decimal](18,2) NOT NULL,
    [PaymentMethod] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_ConcessionSales] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_SaleCode] UNIQUE NONCLUSTERED ([SaleCode] ASC)
);
GO

-- Bảng chi tiết các sản phẩm trong một giao dịch
CREATE TABLE [dbo].[ConcessionSaleItems](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [ConcessionSaleId] [int] NOT NULL,
    [InventoryId] [int] NOT NULL,
    [Quantity] [int] NOT NULL,
    [UnitPrice] [decimal](18,2) NOT NULL,
    [TotalPrice] [decimal](18,2) NOT NULL,
    CONSTRAINT [PK_ConcessionSaleItems] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Thêm các khóa ngoại cho các bảng vừa tạo
PRINT 'Adding foreign keys for new operational tables...';
ALTER TABLE [dbo].[InventoryItems] WITH CHECK ADD CONSTRAINT [FK_InventoryItems_Cinemas] FOREIGN KEY([CinemaId]) REFERENCES [dbo].[Cinemas] ([Id]);
GO
ALTER TABLE [dbo].[Staffs] WITH CHECK ADD CONSTRAINT [FK_Staffs_Cinemas] FOREIGN KEY([CinemaId]) REFERENCES [dbo].[Cinemas] ([Id]);
GO
ALTER TABLE [dbo].[ConcessionSales] WITH CHECK ADD CONSTRAINT [FK_ConcessionSales_Cinemas] FOREIGN KEY([CinemaId]) REFERENCES [dbo].[Cinemas] ([Id]);
GO
ALTER TABLE [dbo].[ConcessionSales] WITH CHECK ADD CONSTRAINT [FK_ConcessionSales_Customers] FOREIGN KEY([CustomerId]) REFERENCES [dbo].[Customers] ([Id]);
GO
ALTER TABLE [dbo].[ConcessionSales] WITH CHECK ADD CONSTRAINT [FK_ConcessionSales_Staffs] FOREIGN KEY([StaffId]) REFERENCES [dbo].[Staffs] ([Id]);
GO
ALTER TABLE [dbo].[ConcessionSaleItems] WITH CHECK ADD CONSTRAINT [FK_ConcessionSaleItems_Sales] FOREIGN KEY([ConcessionSaleId]) REFERENCES [dbo].[ConcessionSales] ([Id]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[ConcessionSaleItems] WITH CHECK ADD CONSTRAINT [FK_ConcessionSaleItems_Inventory] FOREIGN KEY([InventoryId]) REFERENCES [dbo].[InventoryItems] ([Id]);
GO

PRINT 'Operational database [CinemaDW] is now ready for Concession Sales ETL.';
