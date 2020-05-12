<%@ Page Title="Транспорт" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Transport.aspx.cs" Inherits="Rentoolo.Account.Transport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-heading">
                    <h6>Выберите тип объявления:</h6>
                </div>
                <div class="media-body-inline-grid">
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=101';">Автомобили</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102';">Мотоциклы и мототехника</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=104';">Грузовики и спецтехника</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=105';">Водный транспорт</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=106';">Запчасти и аксессуары</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
