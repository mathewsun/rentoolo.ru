<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CaptchaUserControl.ascx.cs" Inherits="Rentoolo.Account.CaptchaUserControl" %>

<%if (!IsLocalhost)
    { %>
<div class="form-group" style="height: 120px;">
    <div class="g-recaptcha" data-sitekey="6Lf4W6QUAAAAAPK2AR7Ms8SsI9_KuJ0l8XZWaTWD"></div>
</div>
<%} %>