<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VueTest.aspx.cs" Inherits="Rentoolo.Test.VueTest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

        <div id="app">
            {{ message }}
            <div @click="some"> click me to log! </div>
        </div>

        <script type="text/javascript">

            var app = new Vue({
                el: '#app',
                data: {
                    message: 'Hello Vue!'
                },
                methods: {
                    some() {
                        console.log("some");
                    }
                }
            });


        </script>

    </div>
</asp:Content>
