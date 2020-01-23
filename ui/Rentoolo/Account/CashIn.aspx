<%@ Page Title="Пополнение баланса" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CashIn.aspx.cs" Inherits="Rentoolo.Account.CashIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript" src="/assets/js/sweet-alert.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="QiwiCashInTable">
        <tr>
            <td colspan="3">
                <span style="color: #3097D1; font-weight: bold;">После пополнения вернитесь пожалуйста на эту страницу и нажмите</span> <span style="color: #269e60; font-weight: bold;">"Проверить оплату"</span>
            </td>
        </tr>
        <tr>
            <td>
                <img src="/assets/img/qiwi_and_cards.jpg" class="cashInImg" />
            </td>
            <td>
                <asp:TextBox ID="QiwiPaymentAmountTextBox" CssClass="cashInCount" ClientIDMode="Static" runat="server">1000.00</asp:TextBox><br />
                <span style="font-size: 11px; white-space: nowrap;">Комментарий не меняйте</span>
            </td>
            <td>
                <input class="btn" style="width: 120px; cursor: pointer; margin-bottom: 18px; background-color: #3097D1; color: #fff;" onclick="ShowQiwiAlert()" value="Пополнить">
            </td>
        </tr>
    </table>

    <br />
    <br />

    <script type="text/javascript">
        function ShowQiwiAlert() {

            var el = document.createElement("img");
            el.src = "/assets/img/qiwi_and_cards.jpg";
            el.width = "200";

            swal({
                title: "Произведите оплату",
                content: el,
                buttons: ["Отмена", "Проверить оплату"],
            }).then((getPay) => {
                if (getPay) {
                    window.open("/Account/Operations.aspx?ch=<%= QiwiAccountCheck %>", "_self")
            } else {

            }
            });

        var url = "https://qiwi.com/payment/form/99?amountFraction=00" +
            "&extra[%27account%27]=" + <%= QiwiAccount %> +
                "&extra[%27comment%27]=id" + <%= User.PublicId %> +
                "&amountInteger=" + $('#QiwiPaymentAmountTextBox').val() +
                "& currency=RUB" +
                "&source=qiwi_RUB";

        var win = window.open(url, '_blank');
        win.focus();
    }
    </script>
</asp:Content>
