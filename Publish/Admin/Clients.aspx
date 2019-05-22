<%@ Page Title="Клиенты" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" CodeBehind="Clients.aspx.cs" Inherits="Rentoolo.Admin.Clients" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h1><%: Title %></h1>
    <hr />
    <br />
    <table class="basicTable marginleft">
        <tr>
            <th>Id
            </th>
            <th>Пользователь
            </th>
            <th>Ip
            </th>
            <th style="width: 80px;">Url
            </th>
            <th>Входил
            </th>
            <th>Кол-во посещений
            </th>
            <th>Кол-во vk активных
            </th>
            <th></th>
        </tr>

    </table>
</asp:Content>
