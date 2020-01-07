<%@ Page Title="Вывод средств" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CashOut.aspx.cs" Inherits="Rentoolo.Account.CashOut" %>

<%@ Import Namespace="Rentoolo.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript" src="/assets/js/sweet-alert.min.js"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="elementsTable">
        <tr>
            <td>Ваш баланс:
            </td>
            <td>
                <span id="balanceValue"><%=Balance.ToString("N2").Replace(",",".")%></span> р.
            </td>
        </tr>
        <tr>
            <td>Укажите сумму для вывода:
            </td>
            <td>
                <asp:TextBox ID="TextBoxCashOut" ClientIDMode="Static" runat="server"></asp:TextBox>
                <input type="hidden" id="balUserval" value="<%=Balance%>" />
                <span id="cashout-percents"></span>
            </td>
        </tr>
        <tr>
            <td>Способ вывода:</td>
            <td>
                <asp:RadioButtonList ID="RadioButtonListCashOutType" ClientIDMode="Static" CssClass="radio-CashOut" runat="server">
                    <asp:ListItem Value="1" Selected="True">Qiwi (вывод в течение 1 минуты) (без комиссии)</asp:ListItem>
                    <asp:ListItem Value="4">BankCard (вывод в течение 1 минуты) (комиссия 2% + 50р)</asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
        <tr>
            <td>Номер кошелька (счет):
            </td>
            <td>
                <asp:TextBox ID="TextBoxNumber" ClientIDMode="Static" placeholder="+79001234567" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="ButtonCashOut" CssClass="btn blueBtn" runat="server" Text="Вывести" OnClick="ButtonCashOut_Click" OnClientClick="if (ValidateForm() == false) return(false);" />
            </td>
        </tr>

    </table>

    <br />

    <%if (list.Count > 0)
        { %>
    <table class="table">
        <tr>
            <th>Сумма</th>
            <th>Способ</th>
            <th>Номер кошелька</th>
            <th>Запрошен</th>
            <th>Статус</th>
            <th>Комментарий</th>
        </tr>
        <% for (int i = 0; list != null && i < list.Count; i++)
            {%>
        <tr class="">
            <td align="center">
                <%= list[i].Value%>
            </td>
            <td>
                <%= list[i].Type != 0 ? CashOutTypes.GetName(list[i].Type) : list[i].Sposob%>
            </td>
            <td>
                <%= list[i].Number%>
            </td>
            <td>
                <%= list[i].WhenDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
            <td>
                <%= CashOutStates.GetName(list[i].State)%>
            </td>
            <td>
                <%= list[i].Comment%>
            </td>
        </tr>
        <% } %>
    </table>
    <%} %>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#RadioButtonListCashOutType input').change(function () {
                SetNumberInfo($(this).val());
                SetCommisionPercents($(this).val());
            });

            $('#TextBoxCashOut').on('input', function (e) {
                SetCommisionPercents();
            });
        });

        function SetCommisionPercents() {
            if ($('#RadioButtonListCashOutType_1').is(":checked")) {
                var cashoutValue = parseFloat($('#TextBoxCashOut').val());
                var percents = cashoutValue / 100 * 2;

                if (isNaN(cashoutValue)) {
                    cashoutValue = 0;
                    $("#cashout-percents").text("");
                }
                else {
                    if (isNaN(percents)) { percents = 0; }

                    $("#cashout-percents").text(" + " + percents.toFixed(2) + "р. + 50р. = " + (percents + 50 + cashoutValue).toFixed(2) + "р.");
                }
            }
            else {
                $("#cashout-percents").text("");
            }
        }

        function SetNumberInfo(val) {
            if (val == "1") {
                $('#TextBoxNumber').attr("placeholder", "+79686399088");
                $('#TextBoxNumber').val('');
            }
            if (val == "2") {
                $('#TextBoxNumber').attr("placeholder", "41001245555267");
                $('#TextBoxNumber').val('');
            }
            if (val == "3") {
                $('#TextBoxNumber').attr("placeholder", "R378887342933");
                $('#TextBoxNumber').val('');
            }
            if (val == "4") {
                $('#TextBoxNumber').attr("placeholder", "5336 6922 8942 8835");
                $('#TextBoxNumber').val('');
            }
            if (val == "5") {
                $('#TextBoxNumber').attr("placeholder", "P1000000");
                $('#TextBoxNumber').val('');
            }
            if (val == "100") {
                $('#TextBoxNumber').attr("placeholder", "Способ и номер счета");
                $('#TextBoxNumber').val('');
            }
        }

        function ValidateForm() {

            if (isNaN(parseFloat($('#TextBoxCashOut').val())) || parseFloat($('#TextBoxCashOut').val()) < 1) {
                swal('Укажите сумму вывода', '', 'warning');
                return false;
            }

            if ($('#TextBoxNumber').val()) {
                if ($('#RadioButtonListCashOutType_1').is(":checked")) {
                    var cashOutValue = parseFloat($("#TextBoxCashOut").val());

                    var cashOutValueWithPercents = cashOutValue + 50 + (cashOutValue / 100 * 2);

                    if (parseFloat($('#balUserval').val()) >= cashOutValueWithPercents) {
                        return true;
                    } else {
                        swal('Недостаточно средств', '', 'warning');

                        return false;
                    }
                }
                else {
                    if (parseFloat($('#balUserval').val()) >= parseFloat($("#TextBoxCashOut").val())) {
                        return true;
                    } else {
                        swal('Недостаточно средств', '', 'warning');

                        return false;
                    }
                }
            } else {
                swal('Укажите Номер кошелька', '', 'warning');

                return false;
            }
        }

        function ShowResult(result) {
            if (result == "1") {
                swal("Запрос на вывод добавлен!", "", "success");
            }

            if (result == "2") {
                //swal('Недостаточно средств', 'Пополните счет!', 'warning');
            }

            if (result == "3") {
                swal("Некорректное значение!", "", "warning");
            }
        }

        $(window).load(function () {
            ShowResult("<%=ResultOrder%>");
        });

    </script>



</asp:Content>
