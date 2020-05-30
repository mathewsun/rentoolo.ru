<%@ Page Title="Аукционы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auctions.aspx.cs" Inherits="Rentoolo.Auctions" %>
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
                            <th>Название
                            </th>
                            <th>Стартовая цена
                            </th>                    
                            <th>Описание
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; ListItems != null && i < ListItems.Count; i++)
                            {%>
                        <tr>
                            <td>
                                <%= ListItems[i].Created.ToString("dd.MM.yyyy HH:mm").Replace(".","/")%>
                            </td>
                            <td class="center">
                                <%= ListItems[i].Name%>
                            </td>
                            <td>
                                <%= ListItems[i].StartPrice.ToString()%> р.
                            </td>
                            <td>
                                <%= ListItems[i].Description%>
                            </td>                     
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
