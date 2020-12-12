<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OpenAuthProviders.ascx.cs" Inherits="Rentoolo.Account.OpenAuthProviders" %>

<asp:ListView runat="server" ID="providerDetails" ItemType="Microsoft.AspNet.Membership.OpenAuth.ProviderDetails"
    SelectMethod="GetProviderNames" ViewStateMode="Disabled">
    <ItemTemplate>
        <button type="submit" name="provider" value="<%#: Item.ProviderName %>"
            title="Log in using your <%#: Item.ProviderDisplayName %> account.">
            <%#: Item.ProviderDisplayName %>
        </button>
    </ItemTemplate>
    <EmptyDataTemplate>
        <div class="message-info">
            <p>Здесь будет регистрация через социалки.</p>
        </div>
    </EmptyDataTemplate>
</asp:ListView>


