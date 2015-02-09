<%@ page import="org.jahia.data.templates.JahiaTemplatesPackage" %>
<%@ page import="org.jahia.registries.ServicesRegistry" %>
<%@ page import="org.jahia.services.render.Resource" %>
<%@ page import="org.jahia.services.templates.JahiaTemplateManagerService" %>
<%@ page import="org.jahia.utils.i18n.ResourceBundles" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocalizationContext" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%--@elvariable id="providerKey" type="java.lang.String"--%>

<%
    Resource currentResource = (Resource) pageContext.findAttribute("currentResource");
    ResourceBundle rb = ResourceBundles.get(ServicesRegistry.getInstance().getJahiaTemplateManagerService().getTemplatePackageById("ldap"), currentResource.getLocale());
    LocalizationContext ctx = new LocalizationContext(rb);
    pageContext.setAttribute("bundle", ctx);
%>

<template:addResources type="javascript" resources="jquery.min.js,jquery.form.min.js"/>
<template:addResources>
    <script type="text/javascript">
        function addField() {
            $("<div class=\"row-fluid\">" +
                    "<div class=\"span4\"><input type=\"text\" name=\"propKey\" value=\"\" required class=\"span12\"/></div>" +
                    "<div class=\"span7\"><input type=\"text\" name=\"propValue\" value=\"\" class=\"span12\"/></div>" +
                    "<div class=\"span1\"><a class=\"btn\" onclick=\"$(this).parent().parent().remove()\"><i class=\"icon icon-minus\"></i></a></div>" +
                    "</div>").insertBefore($("#addField${currentNode.identifier}"));
        }

        <c:if test="${empty ldapProperties}">
        $(document).ready(function () {
            $.ajax({
                type : 'get',
                url: '<c:url value="${url.base}${currentNode.path}.getLdapConfiguration.do"/>',
                <c:if test="${not empty providerKey}">
                data: [{name:'providerKey', value:'${providerKey}'}],
                </c:if>
                dataType: "json",
                success: function(data, textStatus, jqXHR) {
                    $.each(data, function(key, value) {
                        if (key == 'target.site') {
                            $("<input type=\"hidden\" name=\"propKey\" value=\"" + key + "\" />" +
                                    "<input type=\"hidden\" name=\"propValue\" value=\"" + value + "\" />").insertBefore($("#addField${currentNode.identifier}"));
                        } else {
                            $("<label><div class=\"row-fluid\"><div class=\"span4\">" + key +
                                    "<input type=\"hidden\" name=\"propKey\" value=\"" + key +
                                    "\" /></div><div class=\"span7\"><input type=\"text\" name=\"propValue\" value=\"" +
                                    value + "\" class=\"span12\"/></div>" +
                                    "<div class=\"span1\"><a class=\"btn\" onclick=\"$(this).parent().parent().remove()\"><i class=\"icon icon-minus\"></i></a></div>" +
                                    "</div></label>").insertBefore($("#addField${currentNode.identifier}"));
                        }
                    });
                },
                error: function(jqXHR, textStatus, errorThrown) {
                }
            });
        });
        </c:if>
    </script>
</template:addResources>

<fieldset class="box-1">
    <c:forEach var="previousProp" items="${ldapProperties}">
        <c:choose>
            <c:when test="${previousProp.key eq 'target.site'}">
                <input type="hidden" name="propKey" value="${previousProp.key}" />
                <input type="hidden" name="propValue" value="${previousProp.value}" />
            </c:when>
            <c:otherwise>
                <label>
                    <div class="row-fluid">
                        <div class="span4">
                            ${previousProp.key}
                            <input type="hidden" name="propKey" value="${previousProp.key}" class="span12"/>
                        </div>
                        <div class="span7">
                            <input type="text" name="propValue" value="${previousProp.value}" class="span12"/>
                        </div>
                        <div class="span1">
                            <a class="btn" onclick="$(this).parent().parent().remove()"><i class="icon icon-minus"></i></a>
                        </div>
                    </div>
                </label>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <a id="addField${currentNode.identifier}" class="btn" onclick="addField()"><i class="icon icon-plus"></i></a>
</fieldset>