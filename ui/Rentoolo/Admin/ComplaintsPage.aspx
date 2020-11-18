<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ComplaintsPage.aspx.cs" Inherits="Rentoolo.Admin.ComplaintsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <div>
            <div>
                <input type="text" name="objectId" placeholder="objectId"   />
                <input type="text" name="objectType" placeholder="objectType"  />
                <input type="text" name="userSender" placeholder="userSender"  />
                <input type="text" name="userRecipier" placeholder="userRecipier"  />
                <input type="text" name="status" placeholder="status" list="statusList"   />
                <datalist id="statusList">
                    <option>in progress</option>
                    <option>accept</option>
                    <option>reject</option>
                </datalist>

            </div>
            <asp:Button ID="ButtonFilter" runat="server" Text="filter" OnClick="ButtonFilter_Click" />
        </div>
        <div>

            <% foreach (var item in Complaints)
               {%>
                    <div>
                        <h4>
                            <a href="CheckComplaint.aspx?id=<%=item.Id %>">
                                <%= item.Message %>
                            </a>
                        </h4>
                    </div>
                    

            <% } %>

        </div>
        

    </div>
</asp:Content>
