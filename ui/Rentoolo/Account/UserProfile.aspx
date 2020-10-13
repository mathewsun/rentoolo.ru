<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="Rentoolo.Account.UserProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        
        <div>
            
            <h4>
                Профиль пользователя <%= CurUser.UserName %>
            </h4>
            <div>
                
                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Cоздать диалог" />

            </div>
            <div> 
                О пользователе: <%= CurUser.AboutUser %>
            </div>
        </div>
    </div>
</asp:Content>
