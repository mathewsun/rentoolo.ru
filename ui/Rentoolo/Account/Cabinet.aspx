<%@ Page Title="Личный кабинет" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cabinet.aspx.cs" Inherits="Rentoolo.Account.Cabinet" %>

<%@ Import Namespace="Rentoolo.Model" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-logo">
            <h4><%: Title %></h4>
        </div>
        <div class="additem-category">
            <div class="additem-right additem__way" cid="1001">
                <table class="marginTable cabinetTable">
                    <tr>
                        <td>Логин:
                        </td>
                        <td><%=User.UserName %></td>
                    </tr>
                    <tr>
                        <td>Баланс: &nbsp; 
                        </td>
                        <td><%if (UserWalletRURT != null)
                                { %><%=UserWalletRURT.Value.ToString("N2") %><%}
                                                                               else
                                                                               {%>0<%} %>р. <a href="/Account/CashIn.aspx" title="Пополнить">Пополнить</a>
                        </td>
                    </tr>
                </table>
                <div style="padding-top: 15px;">
                    <a href="MyAdverts.aspx" class="button-changePassword settingButton">Мои объявления</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="MyAdverts.aspx" class="button-changePassword settingButton">Вы смотрели</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="Settings.aspx" class="button-changePassword settingButton">Настройки</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="Manage.aspx" class="button-changePassword settingButton">Сменить пароль</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="LoginStatistics.aspx" class="button-changePassword settingButton">Статистика входов</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Account/CashOut.aspx" class="button-changePassword settingButton">Вывод средств</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Tokens.aspx" class="button-changePassword settingButton">Токены</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Account/TokensBuying.aspx" class="button-changePassword settingButton">История покупок токенов</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Account/TokensSelling.aspx" class="button-changePassword settingButton">История продаж токенов</a>
                </div>
                <div style="padding-top: 15px;">
                    Реферальная ссылка:
                    <br />
                    <input id="refferalLink" class="refferalLink" onclick="copyToClipboardUrl()" type="text" title="Скопировать" value="<%=Helper.GetRefferalLink(Request, this.User.PublicId) %>" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        function copyToClipboardUrl() {
            var copyText = document.getElementById("refferalLink");
            copyText.select();
            document.execCommand("copy");
        }

        function copyToClipboardAccountId() {
            var copyText = document.getElementById("accountId");
            copyText.select();
            document.execCommand("copy");
        }
    </script>
</asp:Content>
