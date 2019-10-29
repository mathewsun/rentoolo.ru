<%@ Page Title="Статистика входов" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginStatistics.aspx.cs" Inherits="Rentoolo.Account.LoginStatistics" %>
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
                            <th>Ip
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; ListItems != null && i < ListItems.Count; i++)
                            {%>
                        <tr>
                            <td>
                                <%= ListItems[i].WhenDate.ToString("dd.MM.yyyy HH:mm").Replace(".","/")%>
                            </td>
                            <td class="center">
                                <%= ListItems[i].Ip%>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
