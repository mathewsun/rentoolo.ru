<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManConnection.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManConnection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-sm-9">
            <h1 class="bg-warning text-white"></h1>
            </div>

    <div class="row">
        <div class="col-8 col-sm-6">
            Level 2: .col-8 .col-sm-6
        </div>
        <div class="col-4 col-sm-6">
            Level 2: .col-4 .col-sm-6
        </div>
    </div>
     
    </div>
    <a id="aCollapse" class="btn btn-primary" data-toggle="collapse" href="#myCollapse">
        <span class="glyphicon glyphicon-chevron-down"></span>Открыть
    </a>

    <div class="collapse" id="myCollapse">
        Некоторое содержимое...
    </div>

    <script>
        $(function () {
            $('#myCollapse').on('hide.bs.collapse', function () {
                $('#aCollapse').html('<span class="glyphicon glyphicon-chevron-down"></span> Открыть');
            });
            $('#myCollapse').on('show.bs.collapse', function () {
                $('#aCollapse').html('<span class="glyphicon glyphicon-chevron-up"></span> Закрыть');
            });
        });
    </script>
</asp:Content>
