<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="Rentoolo.Account.UserProfile" EnableEventValidation="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        
        <div>
            
            <h4>
                Профиль пользователя <%= CurUser.UserName %>
            </h4>
            <div>
                <div>
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Cоздать диалог" />
                </div>

                текущий ник - <%= CurUser.UniqueUserName %>
                <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                <asp:Button ID="Button3" runat="server" Text="Задать уникальное имя" OnClick="Button3_Click" />



                <div>
                    <h6>Добавить в чат из списка:
                    <p>
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click1" Text="Присоединить пользователя к чату" />
                    </p>
                <asp:Repeater ID="RptrComments" runat="server" OnItemDataBound="RptrComments_ItemDataBound" OnItemCommand="RptrComments_ItemCommand" >
                    <ItemTemplate>
                        <div>
                            <br />
                            <asp:Button ID="ButtonLike" runat="server" Text='<%#Eval("ChatName") %>' CommandName="Like" CommandArgument='<%#Eval("Id") %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                    </h6>
                    
                    
                    
                    
                    
                    
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
