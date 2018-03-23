<%@ Page Language="C#" ContentType="text/html" ResponseEncoding="gb2312" SmartNavigation="True" AspCompat="true" %>

<html>
<head>
    <title>超级ASPX网站探针</title>
    <meta http-equiv="Content-Language" content="zh-CN">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style type="text/css">
        body {
            font-size: 12px;
        }

        a {
            color: #000000;
            text-decoration: none;
        }

            a:hover {
                color: red;
                font-style: normal;
                text-decoration: underline;
                font-weight: normal;
            }

        .container {
            width: 1000px;
            margin: 10px auto;
        }

        table {
            width: 556px;
            border: 0;
            border-spacing: 0;
            border-collapse: collapse;
            font-size: 9pt;
            border: 1px ridge #669900;
        }

            table tr:nth-child(odd) {
                background: #dbe8db;
            }

            table tr:nth-child(even) {
                background: #edf3ed;
            }
    </style>
</head>
<body>

    <form runat="server">
        <div class="container">
            <p>超级ASP.NET探针 - V1.0</p>

            <%
                if (this.GroupList != null && this.GroupList.Count > 0)
                {
                    foreach (ItemGroup group in this.GroupList)
                    {
            %>
            <p><%=group.Name %></p>
            <%
                if (group.ItemList != null && group.ItemList.Count > 0)
                {
            %>
            <ul>
                <%
                    foreach (Item item in group.ItemList)
                    {
                %>
                <li><span><%=item.Name %></span><%=item.Value %></li>
                <%
                    }
                %>
            </ul>
            <%
                        }
                    }
                }
            %>

            <p>* 其他组件支持情况检测</p>
            <table>
                <tr>
                    <td>输入组件的ProgId或ClassId</td>
                    <td>
                        <asp:TextBox ID="classname" Rows="1" runat="server" TextMode="SingleLine" /></td>
                    <td>
                        <asp:Button ID="classsub" runat="server" Text="检测" OnClick="sub" /></td>
                    <td>
                        <asp:Label ID="classinfo" runat="server" /></td>
                </tr>
            </table>

            <p>服务器性能测试</p>
            <table>
                <tbody>
                    <tr>
                        <td>测试项目</td>
                        <td>使用时间</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>本页执行时间:打开本页面的速度测试</td>
                        <td>
                            <asp:Label ID="timerun" runat="server" /></td>
                        <td><a href="aspx.aspx">重算</a></td>
                    </tr>
                    <tr>
                        <td>整数运算测试:进行100万次加法运算</td>
                        <td>
                            <asp:Label ID="timetol" runat="server" /></td>
                        <td><a href="aspx.aspx">重算</a></td>
                    </tr>
                    <tr>
                        <td>浮点运算测试:进行100万次开方运算</td>
                        <td>
                            <asp:Label ID="timekai" runat="server" /></td>
                        <td><a href="aspx.aspx">重算</a></td>
                    </tr>
                </tbody>
            </table>

        </div>
    </form>
</body>
</html>

<script language="C#" runat="server">

    class Item
    {
        public Item()
        {
        }

        public Item(string name, string value)
        {
            this.Name = name;
            this.Value = value;
        }

        public string Name;

        public string Value;
    }

    class ItemGroup
    {
        public string Name;

        public System.Collections.Generic.List<Item> ItemList;
    }

    System.Collections.Generic.List<ItemGroup> GroupList;

    public void Page_Load(Object sender, EventArgs e)
    {
        GroupList = new System.Collections.Generic.List<ItemGroup>();

        Response.Expires = 0;
        Response.CacheControl = "no-cache";
        if (!Page.IsPostBack)
        {
            //取得页面执行开始时间
            DateTime stime = DateTime.Now;

            {
                ItemGroup group = new ItemGroup();
                group.Name = "服务器的基本参数";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("服务器名", Server.MachineName));
                group.ItemList.Add(new Item("服务器IP", Request.ServerVariables["LOCAL_ADDR"]));
                group.ItemList.Add(new Item("服务器域名", Request.ServerVariables["SERVER_NAME"]));
                group.ItemList.Add(new Item("服务器端口", Request.ServerVariables["SERVER_PORT"]));
                group.ItemList.Add(new Item("服务器时间", DateTime.Now.ToString()));
                group.ItemList.Add(new Item("服务器语言", Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"]));
                group.ItemList.Add(new Item("服务器CPU数量", System.Environment.GetEnvironmentVariable("NUMBER_OF_PROCESSORS")));
                group.ItemList.Add(new Item("服务器CPU结构", System.Environment.GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")));
                group.ItemList.Add(new Item("服务器操作系统", Environment.OSVersion.ToString()));
                group.ItemList.Add(new Item("DotNET引擎版本", ".NET CLR  " + Environment.Version.Major + "." + Environment.Version.Minor + "." + Environment.Version.Build + "." + Environment.Version.Revision));

                GroupList.Add(group);
            }

            {
                ItemGroup group = new ItemGroup();
                group.Name = "服务器的其它参数";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("当前执行用户", Environment.UserName));
                group.ItemList.Add(new Item("系统安装目录", System.Environment.GetEnvironmentVariable("windir")));
                group.ItemList.Add(new Item("系统临时目录", System.Environment.GetEnvironmentVariable("TEMP")));
                group.ItemList.Add(new Item("IIS版本", Request.ServerVariables["SERVER_SOFTWARE"]));
                group.ItemList.Add(new Item("SSL支持", Request.ServerVariables["HTTPS"]));
                group.ItemList.Add(new Item("CGI版本", Request.ServerVariables["GATEWAY_INTERFACE"]));
                group.ItemList.Add(new Item("脚本超时时间", Server.ScriptTimeout.ToString()));
                group.ItemList.Add(new Item("系统运行时间", Math.Round((decimal)(Environment.TickCount / 600 / 60)) / 100 + " 小时"));
                group.ItemList.Add(new Item("当前文件目录", Request.ServerVariables["APPL_PHYSICAL_PATH"]));
                group.ItemList.Add(new Item("当前文件位置", Request.ServerVariables["PATH_TRANSLATED"]));
                group.ItemList.Add(new Item("已使用内存", (Environment.WorkingSet / 1024 / 1024).ToString() + " MB"));
                group.ItemList.Add(new Item("主机所在域", System.Environment.GetEnvironmentVariable("USERDOMAIN")));

                GroupList.Add(group);
            }

            {
                ItemGroup group = new ItemGroup();
                group.Name = "* IIS自带的常用组件";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("MSWC.AdRotator", support("MSWC.AdRotator")));
                group.ItemList.Add(new Item("MSWC.BrowserType", support("MSWC.BrowserType")));
                group.ItemList.Add(new Item("MSWC.NextLink", support("MSWC.NextLink")));
                group.ItemList.Add(new Item("MSWC.Tools", support("MSWC.Tools")));
                group.ItemList.Add(new Item("MSWC.Status", support("AMSWC.Status")));
                group.ItemList.Add(new Item("MSWC.Counters", support("MSWC.Counters")));
                group.ItemList.Add(new Item("IISSample.ContentRotator", support("IISSample.ContentRotator")));
                group.ItemList.Add(new Item("IISSample.PageCounter", support("IISSample.PageCounter")));
                group.ItemList.Add(new Item("MSWC.PermissionChecker", support("MSWC.PermissionChecker")));
                group.ItemList.Add(new Item("Scripting.FileSystemObject(FSO 文本文件读写)", support("Scripting.FileSystemObject")));
                group.ItemList.Add(new Item("Adodb.Connection(ADO 数据对象)", support("ADODB.RecordSet")));

                GroupList.Add(group);
            }

            {
                ItemGroup group = new ItemGroup();
                group.Name = "* 常见的文件上传组件";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("SoftArtisans.FileUp(SA-FileUp 文件上传)", support("SoftArtisans.FileUp")));
                group.ItemList.Add(new Item("SoftArtisans.FileManager(SoftArtisans 文件管理)", support("SoftArtisans.FileManager")));
                group.ItemList.Add(new Item("LyfUpload.UploadFile(刘云峰的文件上传组件)", support("LyfUpload.UploadFile")));
                group.ItemList.Add(new Item("Persits.Upload.1(ASPUpload 文件上传)", support("Persits.Upload")));
                group.ItemList.Add(new Item("w3.upload(Dimac 文件上传)", support("W3.Upload")));

                GroupList.Add(group);
            }

            {
                ItemGroup group = new ItemGroup();
                group.Name = "* 常见的邮件收发组件";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("JMail.SmtpMail(Dimac JMail 邮件收发)", support("JMail.SMTPMail")));
                group.ItemList.Add(new Item("CDONTS.NewMail(虚拟 SMTP 发信)", support("CDONTS.NewMail")));
                group.ItemList.Add(new Item("Persits.MailSender(ASPemail 发信)", support("Persits.MailSender")));
                group.ItemList.Add(new Item("SMTPsvg.Mailer(ASPmail 发信)", support("SMTPsvg.Mailer")));
                group.ItemList.Add(new Item("DkQmail.Qmail(dkQmail 发信)", support("dkQmail.Qmail")));
                group.ItemList.Add(new Item("Geocel.Mailer(Geocel 发信)", support("Geocel.Mailer")));
                group.ItemList.Add(new Item("IISmail.Iismail.1(IISmail 发信)", support("iismail.iismail.1")));
                group.ItemList.Add(new Item("SmtpMail.SmtpMail.1(SmtpMail 发信)", support("SmtpMail.SmtpMail.1")));

                GroupList.Add(group);
            }

            {
                ItemGroup group = new ItemGroup();
                group.Name = "* 常见的图像处理组件";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("SoftArtisans.ImageGen(SA 的图像读写组件)", support("SoftArtisans.ImageGen")));
                group.ItemList.Add(new Item("W3Image.Image(Dimac 的图像读写组件)", support("W3Image.Image")));

                GroupList.Add(group);
            }

            {
                ItemGroup group = new ItemGroup();
                group.Name = "其他";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList.Add(new Item("服务器IP", Request.ServerVariables["LOCAL_ADDR"]));
                group.ItemList.Add(new Item("服务器名", Request.ServerVariables["SERVER_NAME"]));
                group.ItemList.Add(new Item("HTTP端口", Request.ServerVariables["SERVER_PORT"]));
                group.ItemList.Add(new Item("操作系统信息", Request.ServerVariables["HTTP_USER_AGENT"]));
                group.ItemList.Add(new Item("允许文件", Request.ServerVariables["HTTP_ACCEPT"]));
                group.ItemList.Add(new Item("MD目录", Request.ServerVariables["APPL_MD_PATH"]));
                group.ItemList.Add(new Item("探针文件路径", Request.MapPath(Request.ServerVariables["SCRIPT_NAME"])));
                group.ItemList.Add(new Item("IIS版本", Request.ServerVariables["SERVER_SOFTWARE"]));
                group.ItemList.Add(new Item("脚本超时时间(秒)", Server.ScriptTimeout.ToString()));
                group.ItemList.Add(new Item("SLL连接", Request.ServerVariables["HTTPS"]));
                group.ItemList.Add(new Item("CGI版本", Request.ServerVariables["GATEWAY_INTERFACE"]));
                group.ItemList.Add(new Item("服务端语言", Request.ServerVariables["HTTP_ACCEPT_LANGUAGE"]));

                System.Net.IPHostEntry hostInfo = System.Net.Dns.GetHostEntry(Request.ServerVariables["SERVER_NAME"]) as System.Net.IPHostEntry;
                string pingip = hostInfo.AddressList[0].ToString();
                group.ItemList.Add(new Item("Ping结果", pingip));

                GroupList.Add(group);
            }

            {

                ItemGroup group = new ItemGroup();
                group.Name = "客户端信息";
                group.ItemList = new System.Collections.Generic.List<Item>();

                group.ItemList = new System.Collections.Generic.List<Item>();
                HttpBrowserCapabilities userbc = Request.Browser as HttpBrowserCapabilities;

                group.ItemList.Add(new Item("操作系统(2000,NT,XP均显示NT)", userbc.Platform));
                group.ItemList.Add(new Item("浏览器", userbc.Browser + userbc.Version));
                group.ItemList.Add(new Item("ActiveX支持", userbc.ActiveXControls.ToString()));
                group.ItemList.Add(new Item("背景音乐支持", userbc.BackgroundSounds.ToString()));
                group.ItemList.Add(new Item("是否Beta版", userbc.Beta.ToString()));
                group.ItemList.Add(new Item("AOL插件支持", userbc.AOL.ToString()));
                group.ItemList.Add(new Item("Cookies支持", userbc.Cookies.ToString()));
                group.ItemList.Add(new Item("框架支持", userbc.Frames.ToString()));
                group.ItemList.Add(new Item("JavaScript支持", userbc.EcmaScriptVersion.ToString()));
                group.ItemList.Add(new Item("JavaApplets支持", userbc.JavaApplets.ToString()));
                group.ItemList.Add(new Item("VBScript支持", userbc.VBScript.ToString()));

                GroupList.Add(group);

            }

            //取得页面执行结束时间
            DateTime etime = DateTime.Now;
            //计算页面执行时间
            timerun.Text = ((etime - stime).TotalMilliseconds).ToString() + "毫秒";

            //100万次相加循环测试
            DateTime ontime1 = DateTime.Now;
            int sum = 0;
            for (int i = 1; i <= 10000000; i++)
            {
                sum = sum + i;
            }
            DateTime endtime1 = DateTime.Now;
            timetol.Text = ((endtime1 - ontime1).TotalMilliseconds).ToString() + "毫秒";

            //100万次开平方测试
            DateTime ontime2 = DateTime.Now;
            long k = 2;
            for (int a = 1; a < 1000000; a++)
            {
                k = k * k;
            }
            DateTime endtime2 = DateTime.Now;
            timekai.Text = ((endtime2 - ontime2).TotalMilliseconds).ToString() + "毫秒";
        }
    }

    string support(string obj)
    {
        try
        {
            object claobj = Server.CreateObject(obj);

            return "√";
        }
        catch
        {
            return "×";
        }
    }

    //自定义组件查询
    public void sub(Object Sender, EventArgs e)
    {
        string classobj = classname.Text;
        if (support(classobj) == "√")
        {
            classinfo.Text = "检测结果：支持组件" + classobj;
        }
        else
        {
            classinfo.Text = "检测结果：不支持组件" + classobj;
        }
    }

</script>
