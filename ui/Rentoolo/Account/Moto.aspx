<%@ Page Title="Мотоциклы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Moto.aspx.cs" Inherits="Rentoolo.Account.Moto" %>

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
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=10211';">Дорожные</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=10212';">Кросс и эндуро</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=10214';">Спортивные</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=10215';">Чопперы</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=10217';">Кастом-байки</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=1022';">Мопеды и скутеры</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=1023';">Квадроциклы</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=1024';">Вездеходы</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=1025';">Багги</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=1026';">Картинг</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
