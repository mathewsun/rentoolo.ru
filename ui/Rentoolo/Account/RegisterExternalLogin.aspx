<%@ Page Language="C#" Title="Register an external login" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterExternalLogin.aspx.cs" Inherits="Rentoolo.Account.RegisterExternalLogin" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1>Register with your <%: ProviderDisplayName %> account</h1>
        <h2><%: ProviderUserName %>.</h2>
    </hgroup>

    <asp:ModelErrorMessage runat="server" ModelStateKey="Provider" CssClass="field-validation-error" />

</asp:Content>
