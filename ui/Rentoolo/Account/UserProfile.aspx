<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="Rentoolo.Account.UserProfile" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <div class="container">

            <h4>Профиль пользователя <%= CurUser.UserName %>
            </h4>
            <div>
                <div class="col">
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" class="btn-info" Text="перейти к диалогу" />
                </div>

                <div class="col">
                    текущий ник - <%= CurUser.UniqueUserName %>
                    <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                    <asp:Button ID="Button3" runat="server" Text="Задать уникальное имя" OnClick="Button3_Click" />
                </div>
                


                <div class="col">
                    <div>
                        <h6>Добавить в чат из списка:
                        <p>

                            <input name="chatName" type="text" list="chatlist" />
                            <datalist id="chatlist">
                                <% foreach (var chat in ChatList)
                                    { %>

                                <option><%=chat.ChatName %></option>

                                <%} %>
                            </datalist>


                        </p>
                            <p>
                                <asp:Button ID="Button2" runat="server" OnClick="Button2_Click1" Text="Присоединить пользователя к чату" />
                            </p>


                        </h6>

                    </div>






                </div>



            </div>
            <div>
                О пользователе: <%= CurUser.AboutUser %>
            </div>
        </div>

        <script type="text/javascript">
            function some() {
                console.log('some');
            }
        </script>

    </div>
</asp:Content>
