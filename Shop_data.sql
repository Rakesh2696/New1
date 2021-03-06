USE [ShopingDb_2019]
GO
/****** Object:  StoredProcedure [dbo].[Check_MobileNumber]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Check_MobileNumber]
@phonenumber nvarchar(50)
as
begin
select USERID from  New_Transaction where phonenumber=@phonenumber
end
GO
/****** Object:  StoredProcedure [dbo].[New_trans_insert]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[New_trans_insert]
@phonenumber varchar(50)=''
as
begin
INSERT INTO New_Transaction(phonenumber,RegDate)  VALUES(@phonenumber,GETDATE());
SELECT SCOPE_IDENTITY()
end
GO
/****** Object:  StoredProcedure [dbo].[Product_Delete]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Product_Delete]
@pid int
as
begin
delete from Product_tbl where pid=@pid
end
GO
/****** Object:  StoredProcedure [dbo].[Product_Image]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Product_Image]
@Pid int
as
begin
select PImage from Product_tbl where PID=@Pid 
end
GO
/****** Object:  StoredProcedure [dbo].[Product_ImgUpdate]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Product_ImgUpdate]
@PImage image,@PID int,@Pimg_Type varchar(200),@Pimg_Name varchar(200)
as
begin
update Product_tbl set PImage=@PImage,Pimg_Type=@Pimg_Type,Pimg_Name=@Pimg_Name where PID=@PID
end
GO
/****** Object:  StoredProcedure [dbo].[Product_Insert]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Product_Insert]
@PName varchar(200),@PCode varchar(200),@PImage image,@ShellingPrice varchar(200),@BuyingPrice varchar(200),@Pimg_Name varchar(200),@Pimg_Type varchar(200)
as
begin
insert into Product_tbl values(@PName,@PCode,@PImage,@ShellingPrice,@BuyingPrice,GETDATE(),@Pimg_Name,@Pimg_Type)
end
GO
/****** Object:  StoredProcedure [dbo].[Product_Update]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Product_Update]
@pid int,@PName nvarchar(200),@PCode nvarchar(200),@ShellingPrice nvarchar(200),@BuyingPrice nvarchar(200)
as
begin
update Product_tbl set PName=@PName,PCode=@PCode,ShellingPrice=@ShellingPrice,MRPPrice=@BuyingPrice,CreateDate=GETDATE() where PID=@pid
end
GO
/****** Object:  StoredProcedure [dbo].[Trans_History_insert]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Trans_History_insert]
@TransID varchar(50)='',@Barcode varchar(1000)=''
as
begin
insert into Trans_History values(@TransID,@Barcode,GETDATE())
end
GO
/****** Object:  StoredProcedure [dbo].[Validate_User]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Validate_User]
      @Username NVARCHAR(20),
      @Password NVARCHAR(20)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @UserId INT, @LastLoginDate DATETIME, @RoleId INT
     
      SELECT @UserId = UserId, @LastLoginDate = LastLoginDate, @RoleId = RoleId
      FROM Users WHERE Username = @Username AND [Password] = @Password
     
      IF @UserId IS NOT NULL
      BEGIN
            IF NOT EXISTS(SELECT UserId FROM UserActivation WHERE UserId = @UserId)
            BEGIN
                  UPDATE Users
                  SET LastLoginDate = GETDATE()
                  WHERE UserId = @UserId
                 
                  SELECT @UserId [UserId],
                              (SELECT RoleName FROM Roles
                               WHERE RoleId = @RoleId) [Roles] -- User Valid
            END
            ELSE
            BEGIN
                  SELECT -2 [UserId], '' [Roles]-- User not activated.
            END
      END
      ELSE
      BEGIN
            SELECT -1 [UserId], '' [Roles] -- User invalid.
      END
END

GO
/****** Object:  Table [dbo].[New_Transaction]    Script Date: 3/15/2019 11:29:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[New_Transaction](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[phonenumber] [varchar](50) NULL,
	[RegDate] [date] NULL,
 CONSTRAINT [PK_New_Transaction] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product_tbl]    Script Date: 3/15/2019 11:29:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product_tbl](
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[PName] [varchar](100) NULL,
	[PCode] [varchar](100) NULL,
	[PImage] [image] NULL,
	[ShellingPrice] [varchar](50) NULL,
	[MRPPrice] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[Pimg_Name] [varchar](100) NULL,
	[Pimg_Type] [varchar](100) NULL,
 CONSTRAINT [PK_Product_tbl] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Trans_History]    Script Date: 3/15/2019 11:29:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Trans_History](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Trans_ID] [int] NULL,
	[Barcode] [varchar](1000) NULL,
	[Trans_Date] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Trans_History]  WITH CHECK ADD  CONSTRAINT [FK_Trans_History_New_Transaction] FOREIGN KEY([Trans_ID])
REFERENCES [dbo].[New_Transaction] ([UserID])
GO
ALTER TABLE [dbo].[Trans_History] CHECK CONSTRAINT [FK_Trans_History_New_Transaction]
GO
