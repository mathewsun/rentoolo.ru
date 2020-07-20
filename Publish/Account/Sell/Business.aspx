<%@ Page Title="Продажа бизнеса" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Business.aspx.cs" Inherits="Rentoolo.Account.Sell.Business" %>
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
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102011';">Дорожные</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102012';">Кросс и эндуро</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102014';">Спортивные</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102015';">Чопперы</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=10217';">Кастом-байки</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102020';">Мопеды и скутеры</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102030';">Квадроциклы</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102040';">Вездеходы</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102050';">Багги</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block" onclick="location.href = '/Account/AddItem.aspx?cat=102060';">Картинг</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
