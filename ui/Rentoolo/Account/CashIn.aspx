<%@ Page Title="Пополнение баланса" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CashIn.aspx.cs" Inherits="Rentoolo.Account.CashIn" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .paymentButton {
            font-famaly: Verdana, Helvetica, sans-serif !important;
            padding: 0 9px;
            height: 30px;
            font-size: 12px !important;
            border: 1px solid #538ec1 !important;
            background: #a4cef4 !important;
            color: #fff !important;
            width: 72px;
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="QiwiCashInTable">
        <tr>
            <td>
                <img src="/Images/qiwi_and_cards.jpg" style="width: 150px; min-width: 100px;" />
            </td>
            <td>
                <asp:TextBox ID="QiwiPaymentAmountTextBox" CssClass="cashInCount" ClientIDMode="Static" runat="server">1000.00</asp:TextBox><br />
                <span style="font-size: 10px; white-space: nowrap;">Комментарий не меняйте</span>
            </td>
            <td>
                <input class="button cashInButton" style="width: 150px; cursor: pointer;" onclick="ShowQiwiAlert()" value="Пополнить">
            </td>
        </tr>
    </table>

    <br />
    <br />

    <script type="text/javascript">
        function ShowQiwiAlert() {

            var el = document.createElement("img");
            el.src = "/Images/qiwi_and_cards.jpg";
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

            //swal("Произведите оплату", {
            //    buttons: ["Отмена", true],
            //});

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

    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            var topMenu = $("#top-navigation"),
            menuItems = topMenu.find("a");
            menuItems.parent().removeClass("active");
            menuItems.filter("[id*='CashInLink']").parent().addClass("active");
        });
    </script>
</asp:Content>
