<%@ Page Title="Аукционы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auction.aspx.cs" Inherits="Rentoolo.Account.Auction" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="/assets/js/dropzone/dropzone.js"></script>
    <link href="/assets/js/dropzone/dropzone.css" rel="stylesheet">
    <link href="/assets/js/dropzone/basic.css" rel="stylesheet">
    <script src="/assets/js/jsonUtils.js?2"></script>

    <script>
        $(document).ready(function () {
            $("div#mdropzone").dropzone({
                url: "/api/upi",
                addRemoveLinks: true,
                acceptedFiles: ".jpeg,.jpg,.png,.gif",
                resizeWidth: 800,
                resizeHeight: 600,
                resizeMethod: 'contain',
                resizeQuality: 1.0,
                dictDefaultMessage: "Add photos",
                init: function () {
                    this.on("thumbnail", function (file) {
                        if (file.width < 100 || file.height < 100) {
                            alert("Minimum Image resolution 100x100px")
                            this.removeFile(file);
                        }
                    });
                },
                success: function (file, response) {
                    var filaName = response;
                    file.previewElement.classList.add("dz-success");
                    $("#my-dropzone").append($('<input type="hidden" name="AuctionPhotos" ' + 'value="' + filaName + '">'));
                }
            });
         });
    </script>

  
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>

        <%--<asp:Label ID="LabelName" runat="server" Text="Название аукциона:"></asp:Label>

        <br />
        <asp:TextBox ID="TextBoxName" ClientIDMode="Static" runat="server" Width="400px"></asp:TextBox>
        <br />

        <asp:Image ID="Image1" runat="server" Width="404px" />
        <br />
        <asp:Label ID="LabelDescription"  runat="server" Text="Описание:"></asp:Label>
        <br />
        <asp:TextBox ID="TextBoxDescription" ClientIDMode="Static" runat="server" Rows="4" TextMode="MultiLine" Width="400px"></asp:TextBox>
        <br />
        <br />
         <asp:Label ID="LabelPrice" runat="server" Text="Начальная цена:"></asp:Label>
        <asp:TextBox ID="TextBoxPrice" runat="server" Width="81px"></asp:TextBox>

        <br />
        DataEndLife: <br />
        <asp:TextBox ID="TextBoxDataEnd" runat="server"></asp:TextBox>--%>

        <div>
            <input type="text" name="auctionName" placeholder="name" value="<%=CurrentAuction.Name %>" />
            <input type="text" name="description" placeholder="description" value="<%=CurrentAuction.Description %>" />
            <input type="number" name="startPrice" placeholder="start price" value="<%=CurrentAuction.StartPrice %>" />
            <input type="date" name="dateEnd" value="<%=CurrentAuction.DataEnd %>" />



        </div>


        <div>         
            <span class="additem-title">Фотографии</span>
            <div class="image-load">
              <div id="mdropzone" class="dropzone"></div>
              <div id="my-dropzone" style="display: none;"></div> 
            </div>
         </div>
        <br />
        <br />

        <asp:Button ID="ButtonSave" runat="server" Text="Добавить" OnClick="ButtonSave_Click" />
    </div>
</asp:Content>