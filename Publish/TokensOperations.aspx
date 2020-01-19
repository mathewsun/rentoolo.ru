<%@ Page Title="Операции по токенам" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TokensOperations.aspx.cs" Inherits="Rentoolo.TokensOperations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card d-md-block d-lg-block mb-4">
        <div class="card-body">
            <h4><%: Title %></h4>
        </div>
        <div class="card-body">
            <div class="additem-right additem__way" cid="1001">
                <table id="referalTable" class="table">
                    <thead>
                        <tr>
                            <th>Дата
                            </th>
                            <th>Количество
                            </th>
                            <th>Цена токена
                            </th>
                            <th>Сумма
                            </th>
                            <th>Операция
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; ListItems != null && i < ListItems.Count; i++)
                            {%>
                        <tr <% if (ListItems[i].OperationEvent == 0)
                            {%>style="color: darkblue;" <%}
                            else
                            {%>style="color: green;<%} %>">
                            <td>
                                <%= ListItems[i].WhenDate.ToString("dd.MM.yyyy HH:mm").Replace(".","/")%>
                            </td>
                            <td class="center">
                                <%= ListItems[i].Count%>
                            </td>
                            <td>
                                <%= ListItems[i].CostOneToken.ToString()%> р.
                            </td>
                            <td>
                                <%= ListItems[i].FullCost.ToString()%> р.
                            </td>
                            <td>
                                <% if (ListItems[i].OperationEvent == 0)
                                    {%><span style="color: darkblue;">Продажа</span><%}
                                                                                        else
                                                                                        {%><span style="color: green;">Покупка</span>
                                <%} %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
