<%@ Page Title="Статья" Language="C#" MasterPageFile="~/AdminMaster.Master" AutoEventWireup="true" ValidateRequest="false" CodeBehind="ArticleOne.aspx.cs" Inherits="Rentoolo.Admin.ArticleOne" %>

<%@ Register Src="AdminMenu.ascx" TagName="AdminMenu" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

    <script type="text/javascript" src="/Scripts/tinymce/tinymce.min.js"></script>
    <script type="text/javascript">
        tinymce.init({
            forced_root_block: "",
            selector: "textarea#NewsText",
            plugins: [
                "advlist autolink lists link image charmap print preview anchor",
                "searchreplace visualblocks code fullscreen",
                "insertdatetime media table contextmenu paste"
            ],
            toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image"
        });
    </script>
    <script>
        jQuery(function ($) {
            $.datepicker.regional['ru'] = {
                closeText: 'Закрыть',
                prevText: '&#x3c;Пред',
                nextText: 'След&#x3e;',
                currentText: 'Сегодня',
                monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
                'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
                monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
                'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
                dayNames: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
                dayNamesShort: ['вск', 'пнд', 'втр', 'срд', 'чтв', 'птн', 'сбт'],
                dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
                weekHeader: 'Не',
                dateFormat: 'dd.mm.yy',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
            };
            $.datepicker.setDefaults($.datepicker.regional['ru']);
        });

        $(function () {
            $("#TextBoxDate").datepicker();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1><%: Title %></h1>
    </hgroup>
    <table class="elementsTable">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server">Дата публикации:</asp:Label>
            </td>
            <td>
                <asp:TextBox runat="server" ID="TextBoxDate" ClientIDMode="Static" Width="100px" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server">Заголовок</asp:Label></td>
            <td>
                <asp:TextBox runat="server" ID="TextBoxHead" ClientIDMode="Static" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server">Текст</asp:Label></td>
            <td>
                <asp:TextBox runat="server" ID="NewsText" ClientIDMode="Static" TextMode="MultiLine" Rows="25" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server">Автор:</asp:Label></td>
            <td>
                <asp:Label ID="LabelAuthor" runat="server"></asp:Label></td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="ButtonSave" runat="server" Text="Сохранить" OnClick="ButtonSave_Click" /></td>
        </tr>
    </table>
</asp:Content>

