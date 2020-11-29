<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewedItems.aspx.cs" Inherits="Rentoolo.Account.ViewedItems" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h2>Вы смотрели:</h2>
        <div>
            <input type="text" name="category" list="caregories" placeholder="category" />
            <datalist id="caregories">
                <option>product</option>
            </datalist>
            <br />
            StartDate:<input type="date" name="startDate" /> 
            EndDate:<input type="date" name="endDate" />
            <br />
            <asp:Button ID="ButtonSearch" runat="server" Text="show" OnClick="ButtonSearch_Click" />
        </div>
        <div>
            <% foreach (var item in SellItemViews)
                { %>
                    
                    <div>
                        <a href="ViewedItems.aspx?redirect=true&category=<%=item.Type %>&objectId=<%=item.Id %>">
                            <%=item.Name %>
                        </a>
                        
                    </div>
                    

            <%} %>
        </div>
    </div>
</asp:Content>
