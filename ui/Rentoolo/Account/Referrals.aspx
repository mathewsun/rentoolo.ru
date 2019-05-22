<%@ Page Title="Рефералы" Language="C#" MasterPageFile="~/SiteBalance.Master" AutoEventWireup="true" CodeBehind="Referrals.aspx.cs" Inherits="Rentoolo.Account.Referrals" %>

<%@ Import Namespace="Rentoolo.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/Scripts/jquery.tablesorter.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%: Title %></h2>

    <div id="cabinetRefferalLink">
        <div>
            <table>
                <tr>
                    <td colspan="3">Ссылка для привлечения рефералов: </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <input id="refferalLink" onclick="copyToClipboardUrl()" type="text" style="border: none; background: transparent; color: #181A1C; font-size: 17px; width: 400px; -webkit-appearance: none; box-shadow: inset 0px 0px 0px 0px red; cursor: pointer;" title="Скопировать" value="<%=Helper.GetRefferalLink(Request, User.PublicId) %>" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div>
            Вы получаете процент от дохода ваших рефералов. Начисления происходят ежедневно в конце дня.
        </div>
        <br />
        <div>
            Cookies хранятся в течение года.
        </div>
    </div>
    <br />
    <hr />
    <br />
    Общий доход от рефералов сегодня: <span id="TotalBalanceAddToday"></span>руб. Всего: <span id="TotalBalanceAdd"></span>руб
    <br />
    <hr />
    <br />
    <div>
        Рефералы I-го уровня, начисления <%=ReferralsPercentFirstLevel %>% :
    </div>
    <table id="referalTable" class="basicTable referalTable">
        <thead>
            <tr>
                <th>Номер
                </th>
                <th>Реферал (номер счета)
                </th>
                <th>Дата регистрации
                </th>
                <th>Доход сегодня
                </th>
                <th>Общий доход
                </th>
            </tr>
        </thead>
        <tbody>
            <% for (int i = 0; ListItemsFirstLevel != null && i < ListItemsFirstLevel.Count; i++)
                {%>
            <tr>
                <td>
                    <%= i + 1%>
                </td>
                <td class="center">
                    <% Users user = DataHelper.GetUser(ListItemsFirstLevel[i].ReferralUserId); %>
                    <%= user.PublicId%>
                </td>
                <td>
                    <%= ListItemsFirstLevel[i].WhenDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm").Replace(".","/")%>
                </td>
                
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr style="border-top: 1px dashed #69c;">
                <td colspan="3">Итого:</td>
                <td><span id="TotalBalanceRefFirstAddToday"></span>руб.</td>
                <td><span id="TotalBalanceRefFirstAdd"></span>руб.</td>
            </tr>
        </tfoot>
    </table>
    <br />
    <hr />
    <br />
    <div>
        Рефералы II-го уровня, начисления <%=ReferralsPercentSecondLevel %>% :
    </div>
    <table id="Table2" class="basicTable referalTable">
        <thead>
            <tr>
                <th>Номер
                </th>
                <th>Реферал (номер счета)
                </th>
                <th>Дата регистрации
                </th>
                <th>Доход сегодня
                </th>
                <th>Общий доход
                </th>
            </tr>
        </thead>
        <tbody>
            <% for (int i = 0; ListItemsSecondLevel != null && i < ListItemsSecondLevel.Count; i++)
                {%>
            <tr>
                <td>
                    <%= i + 1%>
                </td>
                <td class="center">
                    <% Users user = DataHelper.GetUser(ListItemsSecondLevel[i].ReferralUserId); %>
                    <%= user.PublicId%>
                </td>
                <td>
                    <%= ListItemsSecondLevel[i].WhenDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm").Replace(".","/")%>
                </td>
                
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr style="border-top: 1px dashed #69c;">
                <td colspan="3">Итого:</td>
                <td><span id="TotalBalanceRefSecondAddToday"></span>руб.</td>
                <td><span id="TotalBalanceRefSecondAdd"></span>руб.</td>
            </tr>
        </tfoot>
    </table>
    <br />
    <hr />
    <br />
    <div>
        Рефералы III-го уровня, начисления <%=ReferralsPercentThirdLevel %>% :
    </div>
    <table id="Table1" class="basicTable referalTable">
        <thead>
            <tr>
                <th>Номер
                </th>
                <th>Реферал (номер счета)
                </th>
                <th>Дата регистрации
                </th>
                <th>Доход сегодня
                </th>
                <th>Общий доход
                </th>
            </tr>
        </thead>
        <tbody>
            <% for (int i = 0; ListItemsThirdLevel != null && i < ListItemsThirdLevel.Count; i++)
                {%>
            <tr>
                <td>
                    <%= i + 1%>
                </td>
                <td class="center">
                    <% Users user = DataHelper.GetUser(ListItemsThirdLevel[i].ReferralUserId); %>
                    <%= user.PublicId%>
                </td>
                <td>
                    <%= ListItemsThirdLevel[i].WhenDate.AddHours(HoursDifference).ToString("dd.MM.yyyy HH:mm").Replace(".","/")%>
                </td>
                
            </tr>
            <% } %>
        </tbody>
        <tfoot>
            <tr style="border-top: 1px dashed #69c;">
                <td colspan="3">Итого:</td>
                <td><span id="TotalBalanceRefThirdAddToday"></span>руб.</td>
                <td><span id="TotalBalanceRefThirdAdd"></span>руб.</td>
            </tr>
        </tfoot>
    </table>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".referalTable").tablesorter({ dateFormat: "uk" });

            var TotalBalanceRefFirstAddToday = 0;

            $(this).find(".balanceFirstLevelAddToday").each(function () {
                var txt = $(this).text();
                var sum = txt ? txt.replace(',', '.') * 1 : 0;
                TotalBalanceRefFirstAddToday = TotalBalanceRefFirstAddToday + sum;
            });

            $("#TotalBalanceRefFirstAddToday").text(TotalBalanceRefFirstAddToday.toFixed(2));

            var TotalBalanceRefFirstAdd = 0;

            $(this).find(".balanceFirstLevelAdd").each(function () {
                var txt = $(this).text();
                var sum = txt ? txt.replace(',', '.') * 1 : 0;
                TotalBalanceRefFirstAdd = TotalBalanceRefFirstAdd + sum;
            });

            $("#TotalBalanceRefFirstAdd").text(TotalBalanceRefFirstAdd.toFixed(2));

            //----2

            var TotalBalanceRefSecondAddToday = 0;

            $(this).find(".balanceSecondLevelAddToday").each(function () {
                var txt = $(this).text();
                var sum = txt ? txt.replace(',', '.') * 1 : 0;
                TotalBalanceRefSecondAddToday = TotalBalanceRefSecondAddToday + sum;
            });

            $("#TotalBalanceRefSecondAddToday").text(TotalBalanceRefSecondAddToday.toFixed(2));

            var TotalBalanceRefSecondAdd = 0;

            $(this).find(".balanceSecondLevelAdd").each(function () {
                var txt = $(this).text();
                var sum = txt ? txt.replace(',', '.') * 1 : 0;
                TotalBalanceRefSecondAdd = TotalBalanceRefSecondAdd + sum;
            });

            $("#TotalBalanceRefSecondAdd").text(TotalBalanceRefSecondAdd.toFixed(2));

            //-----3

            var TotalBalanceRefThirdAddToday = 0;

            $(this).find(".balanceThirdLevelAddToday").each(function () {
                var txt = $(this).text();
                var sum = txt ? txt.replace(',', '.') * 1 : 0;
                TotalBalanceRefThirdAddToday = TotalBalanceRefThirdAddToday + sum;
            });

            $("#TotalBalanceRefThirdAddToday").text(TotalBalanceRefThirdAddToday.toFixed(2));

            var TotalBalanceRefThirdAdd = 0;

            $(this).find(".balanceThirdLevelAdd").each(function () {
                var txt = $(this).text();
                var sum = txt ? txt.replace(',', '.') * 1 : 0;
                TotalBalanceRefThirdAdd = TotalBalanceRefThirdAdd + sum;
            });

            $("#TotalBalanceRefThirdAdd").text(TotalBalanceRefThirdAdd.toFixed(2));

            //---

            $("#TotalBalanceAddToday").text((TotalBalanceRefFirstAddToday + TotalBalanceRefSecondAddToday + TotalBalanceRefThirdAddToday).toFixed(2));

            $("#TotalBalanceAdd").text((TotalBalanceRefFirstAdd + TotalBalanceRefSecondAdd + TotalBalanceRefThirdAdd).toFixed(2));

        });

        function copyToClipboardUrl() {
            var copyText = document.getElementById("refferalLink");
            copyText.select();
            document.execCommand("copy");
        }

    </script>

    <script type="text/javascript">
        jQuery(document).ready(function ($) {
            var topMenu = $("#top-navigation"),
            menuItems = topMenu.find("a");
            menuItems.parent().removeClass("active");
            menuItems.filter("[id*='RefferalsLink']").parent().addClass("active");
        });
    </script>
</asp:Content>
