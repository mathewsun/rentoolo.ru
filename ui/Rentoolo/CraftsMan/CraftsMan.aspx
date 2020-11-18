<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsMan.aspx.cs" Inherits="Rentoolo.Craftsman" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-heading">
                    <h6>В какой сфере Вам нужен мастер?:</h6>
                </div>
                <div class="media-body-inline-grid">
                   
                    <asp:Button ID="Button1" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Мастера по ремонту" OnClick="Click_Artists" />
                    <asp:Button ID="Button2" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Домашний персонал" OnClick="Click_DomesticStaff" />
                    <asp:Button ID="Button3" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Фрилансеры" OnClick="Click_Freelance" />
                    <asp:Button ID="Button4" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Репетиторы и обучение" OnClick="Click_TutorsAndCoaches" />
                 <%--   <asp:Button ID="Button5" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Тренеры" OnClick="" />
                    <asp:Button ID="Button6" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Курьеры и Грузоперевозки" OnClick="" />
                    <asp:Button ID="Button7" class="btn btn-secondary btn-lg btn-block" runat="server" Text="Разное" OnClick="" />--%>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
