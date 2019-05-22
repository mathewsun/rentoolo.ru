<%@ Page Title="Регистрация" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Rentoolo.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="/Scripts/helper.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var refid = getParameterByName("refid");

            if (!!refid) {
                var date = new Date(new Date().getTime() + 31536000000);
                document.cookie = "refid=" + refid + "; path=/; expires=" + date.toUTCString();
            }
        });
    </script>
    <script src='https://www.google.com/recaptcha/api.js'></script>
</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <h2>Регистрация</h2>

    <asp:CreateUserWizard runat="server" ID="RegisterUser" ViewStateMode="Disabled" OnCreatingUser="RegisterUser_CreatingUser" OnCreatedUser="RegisterUser_CreatedUser">
        <LayoutTemplate>
            <asp:PlaceHolder runat="server" ID="wizardStepPlaceholder" />
            <asp:PlaceHolder runat="server" ID="navigationPlaceholder" />
        </LayoutTemplate>
        <WizardSteps>
            <asp:CreateUserWizardStep runat="server" ID="RegisterUserWizardStep">
                <ContentTemplate>
                    <p class="validation-summary-errors">
                        <asp:Literal runat="server" ID="ErrorMessage" />
                    </p>
                    <table class="elementsTable registerTable">
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" AssociatedControlID="UserName">Пользователь</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox runat="server" CssClass="user-register" ID="UserName" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserName"
                                    CssClass="field-validation-error" ErrorMessage="*" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" AssociatedControlID="Email">Email</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox runat="server" CssClass="user-register" ID="Email" TextMode="Email" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Email"
                                    CssClass="field-validation-error" ErrorMessage="*" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label3" runat="server" AssociatedControlID="Password">Пароль</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox runat="server" CssClass="user-register" ID="Password" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Password"
                                    CssClass="field-validation-error" ErrorMessage="*" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label4" runat="server" AssociatedControlID="ConfirmPassword">Подтверждение</asp:Label>
                            </td>
                            <td>
                                <asp:TextBox runat="server" CssClass="user-register" ID="ConfirmPassword" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ConfirmPassword"
                                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="*" />
                                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="Не совпадают" />
                            </td>
                        </tr>
                        <tr>
                           <td colspan="2">
                                <div style="margin-left:10px;" class="g-recaptcha" data-sitekey="6Lf4W6QUAAAAAPK2AR7Ms8SsI9_KuJ0l8XZWaTWD"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="Button1" runat="server" CssClass="button button-register" CommandName="MoveNext" Text="Зарегистрироваться" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                <CustomNavigationTemplate />
            </asp:CreateUserWizardStep>
        </WizardSteps>
    </asp:CreateUserWizard>
</asp:Content>
