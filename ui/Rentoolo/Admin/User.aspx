<%@ Page Title="Пользователь" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="Rentoolo.Admin.User" %>

<%@ Import Namespace="Rentoolo.Model" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>

    <table class="elementsTable">
        <tr>
            <td>Пользователь:
            </td>
            <td>
                <asp:Label ID="LabelUserName" runat="server" />
            </td>
        </tr>
        <tr>
            <td>Реферер:
            </td>
            <td>
                <a href="User.aspx?id=<%=Referer != null ? Referer.ReferrerUserId.ToString() : "" %>">
                    <asp:Label ID="LabelReferal" runat="server" /></a>
            </td>
        </tr>
        <tr>
            <td>PublicId:
            </td>
            <td>
                <%=UserItem.PublicId %>
            </td>
        </tr>
        <tr>
            <td>Телефон:
            </td>
            <td>
                <%=UserItem.Communication %>
            </td>
        </tr>
        <tr>
            <td>Email:
            </td>
            <td>
                <asp:Label ID="LabelEmail" runat="server" />
            </td>
        </tr>
        <tr>
            <td>Заблокирован:
            </td>
            <td>
                <asp:Label ID="LabelUserIsBlocked" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <table class="basicTable">
                    <tr>
                        <th>Зарегистрирован
                        </th>
                        <th>Входил
                        </th>
                        <th>Заработано
                        </th>
                        <th>Рефелаьных
                        </th>
                        <th>Потрачено
                        </th>
                        <th>Внесено
                        </th>
                        <th>Выведено
                        </th>
                        <th>Рефералов
                        </th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="LabelRegistered" runat="server" />
                        </td>
                        <td>
                            <%=UserItem.LastActivityDate.ToString("dd.MM.yyyy HH:mm") %>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <a href="Referrals.aspx?UserId=<%= UserItem.UserId%>"><%=DataHelper.GetUserReferralsCountFirsLavel(UserItem.UserId) %></a>
                        </td>
                        <td>
                            <a href="Orders.aspx?UserId=<%= UserItem.UserId%>">Заказы</a>
                        </td>
                        <td>
                            <a href="CashOut.aspx?UserId=<%= UserItem.UserId%>">Вывод средств</a>
                        </td>
                        <td>
                            <a href="Operations.aspx?UserId=<%= UserItem.UserId%>">Операции</a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td>Управление:</td>
            <td>
                <table>
                    <tr>
                        <td>
                            <asp:Button ID="ButtonBlock" runat="server" Text="Заблокировать" OnClick="ButtonBlock_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="ButtonUnBlock" runat="server" Text="Разблокировать" OnClick="ButtonUnBlock_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <hr />
    Статистика входа:
    <br />
    <table class="basicTable">
        <tr>
            <th></th>
            <th>Ip
            </th>
            <th>Крайнее обращение
            </th>
            <th>Количество
            </th>
            <th>Клиент</th>
            <th>С таким же ip</th>
        </tr>
        <% for (int i = 0; ListLoginStatistics != null && i < ListLoginStatistics.Count; i++)
            { %>
        <tr>
            <td>
                <%=i%>
            </td>
            <td>
                <a href="Ips.aspx?ip=<%=ListLoginStatistics[i].Ip%>"><%= ListLoginStatistics[i].Ip %></a>
            </td>
            <td>
                <%=ListLoginStatistics[i].WhenLastDate.ToString("dd.MM.yyyy HH:mm")%>
            </td>
            <td>
                <%=ListLoginStatistics[i].Count%>
            </td>
            <td>
                <%= ListLoginStatistics[i].Client == 0 ? "Сайт" : "Клиент" %>
            </td>
            <td><%= DataHelper.GetLoginStatisticByIp(ListLoginStatistics[i].Ip)%></td>
        </tr>
        <% } %>
    </table>
</asp:Content>
