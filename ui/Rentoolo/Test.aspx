<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="Rentoolo.Test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
    <html>
    <head>
        <title>TEST</title>
        <script>
            $(document).ready(function () {
                $.get("Events.ashx?e=af&b&id=222", function (data) {
                    var ttt = 10;
                });
            });
        </script>
    </head>

    <body class="first id1 www">
        <div>
            456

        </div>

    </body>

    </html>

</asp:Content>
