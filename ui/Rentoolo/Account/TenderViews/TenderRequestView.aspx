<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TenderRequestView.aspx.cs" Inherits="Rentoolo.Account.TenderViews.TenderRequestView" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h3>
            Заявка на тендер
        </h3>
        <div>
            Описание: <%= TenderRequest.Description %> <br />
            Цена: <%= TenderRequest.Cost  %>

        </div>
        <div>
            <form>
               <asp:Button ID="ButtonAccept" runat="server" Text="Выбрать эту заявку для исполнения поставщиком" OnClick="ButtonAccept_Click" />
            </form>
        </div>
    </div>
</asp:Content>
