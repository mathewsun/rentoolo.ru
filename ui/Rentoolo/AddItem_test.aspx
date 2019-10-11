<%@ Page Title="Подать объявление" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddItem_test.aspx.cs" Inherits="Rentoolo.AddItem_test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="list-group media-list media-list-stream mb-4">
        <li class="media list-group-item p-4">
            <div class="media-body">
                <div class="media-body-inline-grid">
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Купить/продать</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Выставить в аренду</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Продать через аукцион</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Выставить тендер</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Предложить работу</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Предложить услуги</button>
                    <button type="button" class="btn btn-secondary btn-lg btn-block">Токены площадки</button>
                </div>
            </div>
        </li>
    </ul>
</asp:Content>
