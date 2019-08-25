<%@ Page Title="Токены" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tokens.aspx.cs" Inherits="Rentoolo.Tokens" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card d-md-block d-lg-block mb-4">
        <div class="card-body">
            <h6 class="mb-3">У вас токенов: 0</h6>
            <h6 class="mb-3">Всего токенов: 10 000 000 000</h6>
            <h6 class="mb-3">Токенов, доступных к покупке: 4 900 000 000</h6>
            <h6 class="mb-3">Стоимость токена сегодня: 0.10р.</h6>
            <h6 class="mb-3">Доход Rentoolo сегодня: 0р.</h6>
            <h6 class="mb-3">Доход одного токена сегодня: 0р.</h6>
            <div>
                Изначально в продаже доступно 49% от общего количества токенов. 
                <br />
                Список сделок покупки и продажи доступен ниже. 
                <br />
                Каждый токен приносит доход в равной доли от общего количества токенов.
                <br />
                Купить и продать токены можно в любой момент.
                <br />
                Rentoolo обеспечивает 15% годовых с ежесуточным ростом стоимости токенов до тех пор, пока не будут проданы доступные токены, далее стоимость зависит от рыночной востребованности.
            </div>
            <br />
            <br />
            <div style="display: -webkit-box;">
                <input type="text" class="form-control placeholder-right" style="width: 80px;" value="1000" />
                <div class="input-group-btn" style="padding-left: 20px;">
                    <button class="btn btn-primary" type="button">
                        Купить токены
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
