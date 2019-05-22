<%@ Page Title="Перевод средств" Language="C#" MasterPageFile="~/SiteBalance.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="Rentoolo.Account.Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="elementsTable">
        <tr>
            <td>Ваш номер счёта:
            </td>
            <td style="padding-left: 0px;">
                <%=User.PublicId %>
            </td>
        </tr>
        <tr>
            <td>Счёт получателя:
            </td>
            <td style="padding-left: 0px;">
                <asp:TextBox ID="TextBoxPaymentAddress" ClientIDMode="Static" style="width: 150px;" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Сумма:
            </td>
            <td style="padding-left: 0px;">
                <asp:TextBox ID="TextBoxPaymentValue" ClientIDMode="Static" style="width: 150px;" runat="server"></asp:TextBox>
                <input type="hidden" id="balUserval" value="<%=Balance%>" />
            </td>
        </tr>
        <tr>
            <td>Комментарий:
            </td>
            <td style="padding-left: 0px;">
                <asp:TextBox ID="TextBoxPaymentComment" ClientIDMode="Static" style="width: 150px;" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="ButtonMakePayment" CssClass="button" runat="server" Text="Перевести" OnClick="ButtonMakePayment_Click" OnClientClick="if (ValidateForm() == false) return(false);" />
            </td>
        </tr>
    </table>

    <script type="text/javascript">
        function ValidateForm() {

            if ($('#TextBoxPaymentAddress').val()) {

                if (isNaN(parseFloat($('#TextBoxPaymentValue').val())) || parseFloat($('#TextBoxPaymentValue').val()) < 1) {
                    swal('Укажите сумму перевода', '', 'warning');
                    return false;
                }

                if (parseFloat($('#balUserval').val()) >= parseFloat($("#TextBoxPaymentValue").val())) {
                    return true;
                } else {
                    swal('Недостаточно средств', '', 'warning');
                    return false;
                }
            } else {
                swal('Укажите счёт получателя', '', 'warning');
                return false;
            }
        }

        function ShowResult(result) {
            if (result == "1") {
                swal("Перевод выполнен!", "", "success");
            }

            if (result == "2") {
                swal('Недостаточно средств', 'Пополните счет!', 'warning');
            }

            if (result == "3") {
                swal("Некорректное значение!", "", "warning");
            }
        }

        $(window).load(function () {
            ShowResult("<%=ResultOrder%>");
        });

    </script>

    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            var topMenu = $("#top-navigation"),
            menuItems = topMenu.find("a");
            menuItems.parent().removeClass("active");
            menuItems.filter("[id*='PaymentLink']").parent().addClass("active");
        });
    </script>
</asp:Content>
