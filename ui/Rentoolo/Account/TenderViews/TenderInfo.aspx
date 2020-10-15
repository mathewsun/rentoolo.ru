<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TenderInfo.aspx.cs" Inherits="Rentoolo.Account.TenderInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <div>
            <a href="Tenders.aspx">
                <h5>Вернуться к списку тендеров</h5>
            </a>
            <a href="/Account/TenderViews/TenderRequests.aspx?id=<%=tender.Id %>">
                <h4>Показать список запросов на тендер</h4>
            </a>
            <h2>Tender Info</h2>
            <div>
                <h4>
                    <%= tender.Name %>
                </h4>
                <p>
                    Description: 
                    <%= tender.Description %>
                </p>
                <p>
                    Created: <%= tender.Created %>
                </p>
                <p>
                    Cost: <%= tender.Cost %>
                </p>

            </div>
        </div>
        <div>
            <form>
                <%--<input type="text" name="description" id="desc" />--%>
                <asp:TextBox ID="TextBoxDescription" ClientIDMode="Static" runat="server" ToolTip="Описание" ></asp:TextBox>
                <!-- <input type="text" name="cost" id="cost" /> -->
                <asp:TextBox ID="TextBoxCost" ClientIDMode="Static" runat="server"></asp:TextBox>
                <!-- <button onclick="sendForm()">создать запрос на тендер</button> -->
                <asp:Button ID="ButtonAddRequest" runat="server" Text="Создать запрос на тендер" OnClick="ButtonAddRequest_Click" />
            </form>
        </div>
       
    </div>

    <script type="text/javascript">

        function sendForm() {
            let desc = document.getElementById("desc").nodeValue;
            let cost = document.getElementById("cost").nodeValue;

            let data = {};
            data["description"] = desc;
            data["cost"] =  cost;
            data["tenderId"] =  <%=tender.Id %>;
            data["userOwnerId"] = <%= tender.UserOwnerId %>;

            let url = "TenderRequest"

            fetch(url, {
                body: JSON.stringify(data),
                method: "post",
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((response) => {
                return response.json();
            }).then((data) => {
                console.log(data);
                }).catch((e) => {
                    console.log(e);
                });



        }

    </script>

</asp:Content>
