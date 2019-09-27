<%@ Page Title="Настройки" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Rentoolo.Account.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        function EditValue(value) {

            $("#TextBox" + value).addClass("cabinetTextBoxVisible");
            $("#TextBox" + value).prop('readonly', false);
            $('#edit' + value).hide();
            $('#edit' + value + 'Ok').show();
        }

        function SaveValue(value) {

            $("#TextBox" + value).removeClass("cabinetTextBoxVisible");

            if ($('#TextBox' + value).val().length == 0 && value == 'Referrer') {
                swal('Укажите id реферера', '', 'warning');
                return false;
            }

            if (value == 'Referrer') {
                $('#editReferrerOk').hide();
            }

            $('#TextBox' + value).prop('readonly', true);
            $('#edit' + value + 'Ok').hide();
            $('#edit' + value).show();

            var result = $('#TextBox' + value).val();

            $.ajax({
                url: "Result.ashx?eventName=saveUserParam&id=" + value + "&result=" + result
            }).done(function () { }
            );
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-logo">
            <h4><%: Title %></h4>
        </div>
        <div class="additem-category">
            <div class="additem-right additem__way" cid="1001">
                <table class="marginTable settingsTable">
                    <tr>
                        <td>Email:</td>
                        <td>
                            <asp:TextBox ID="TextBoxEmail" ClientIDMode="Static" ReadOnly="true" CssClass="settingsTextBoxVisible" runat="server"></asp:TextBox></td>
                        <td>
                            <img alt="Редактировать" src="/assets/img/icon_edit.png" id="editEmail" title="Редактировать" class="pointer" onclick="EditValue('Email')" />
                            <img alt="Сохранить" src="/assets/img/slready16.png" id="editEmailOk" style="display: none;" title="Сохранить" class="pointer" onclick="SaveValue('Email')" />
                        </td>
                    </tr>
                    <tr>
                        <td>Телефон:</td>
                        <td>
                            <asp:TextBox ID="TextBoxCommunication" ClientIDMode="Static" ReadOnly="true" CssClass="settingsTextBoxVisible" runat="server"></asp:TextBox></td>
                        <td>
                            <img alt="Редактировать" src="/assets/img/icon_edit.png" id="editCommunication" title="Редактировать" class="pointer" onclick="EditValue('Communication')" />
                            <img alt="Сохранить" src="/assets/img/slready16.png" id="editCommunicationOk" style="display: none;" title="Сохранить" class="pointer" onclick="SaveValue('Communication')" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
