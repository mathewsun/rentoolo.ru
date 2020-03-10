<%@ Page Title="Выберите тип объявления" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="Rentoolo.Account.Category" %>

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
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/SellCategory.aspx';" >Продажа</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Аренда</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Аукцион</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Тендер</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Вакансия</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Услуги</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
