<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManStartPage.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManStartPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-heading">
                    <h6>Раздел разовых работ</h6>
                </div>
                <div class="media-body-inline-grid">
                    <button type="button" class="btn btn-outline-success btn-lg btn-block" onclick="location.href = 'CraftsManOrder.aspx';" >Создать задание</button>
                    <button type="button" class="btn btn-outline-primary btn-lg btn-block" onclick="location.href = 'CraftsManResume.aspx';">Создать резюме</button>
                    <button type="button" class="btn btn-outline-success btn-lg btn-block" onclick="location.href = 'CraftsManTasks.aspx';">Найти задание</button>
                    <button type="button" class="btn btn-outline-primary btn-lg btn-block" onclick="location.href = 'CraftsManPage.aspx';">Найти исполнителя</button> 
                </div>
            </div>
        </li>
         
    </ul>
</asp:Content>
