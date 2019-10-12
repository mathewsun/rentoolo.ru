<%@ Page Title="Выберите категорию" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="Rentoolo.Category" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-heading">
                    <small class="float-right text-muted">8 adverts</small>
                    <h6>Категории:</h6>
                </div>
                <div class="media-body-inline-grid">
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Транспорт</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Недвижимость</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Работа</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Услуги</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Личные вещи</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Для дома и дачи</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Бытовая электроника</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Хобби и отдых</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Животные</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Для бизнеса</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
