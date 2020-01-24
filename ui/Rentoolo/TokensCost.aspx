<%@ Page Title="Стоимость токена" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TokensCost.aspx.cs" Inherits="Rentoolo.TokensCost" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.3.0/Chart.bundle.js"></script>

    <script>

        $(document).ready(function () {

            var result = <%=jsonTokensCosts %>;

        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    

    <div class="container">
        <canvas id="examChart"></canvas>
    </div>

</asp:Content>
