<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="CheckComplaint.aspx.cs" Inherits="Rentoolo.Admin.CheckComplaint" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>


     <input type="number" name="id"  value="<%=Complaint.Id%>" />
    <input type="text" name="name"  value="<%=Complaint.Name%>" />
    <input type="text" name="description"  value="<%=Complaint.Description%>" />
    <input type="text" name="userOwnerId"  value="<%=Complaint.UserOwnerId%>" />
    <input type="number" name="cost"  value="<%=Complaint.Cost%>" />
    <input type="text" name="imgUrls"  value="<%=Complaint.ImgUrls%>" />
    <input type="text" name="status"  value="<%=Complaint.Status%>" />
    <input type="date" name="created"  value="<%=Complaint.Created%>" />
    <input type="number" name="currencyId"  value="<%=Complaint.CurrencyId%>" />
    <input type="number" name="categoryId"  value="<%=Complaint.CategoryId%>" />
        


    </div>
</asp:Content>
