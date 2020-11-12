<%@ Page Title="Автомобили" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auto.aspx.cs" Inherits="Rentoolo.Account.Auto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-heading">
                    <h6>Выберите тип автомобиля:</h6>
                </div>
                <div class="media-body-inline-grid">
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItemCar.aspx?cat=101010';">Новый</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItemCar.aspx?cat=101020';">С пробегом</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>