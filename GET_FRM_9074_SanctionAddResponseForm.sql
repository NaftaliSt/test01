DECLARE @ServiceName nvarchar(225) = N'GET_FRM_9074_SanctionAddResponseForm'
DECLARE @ServiceNumber nvarchar(225) = N'FRM_9074'
DECLARE @ModuleId nvarchar(225) = N'37'
DECLARE @ServiceDescription nvarchar(225) = N'קבלת תגובת מפוקח לתיק עיצום'
DECLARE @ServiceAddressIdMSMQ1 uniqueidentifier= N'03863816-AF15-4A58-8589-FC187C3AC569'
DECLARE @ServiceAddressIdHTTP1 uniqueidentifier= N'4617D76F-ED27-44F6-B217-3A17E7D63B0A'
DECLARE @EndpointMSMQ1 nvarchar(225)= N'http://tempuri.org/IInvestigationInternalIncomingMessagen/ENF_FRM_9074_SanctionAddResponseForm'
DECLARE @EndpointHTTP1 nvarchar(225)= N'http://tempuri.org/IInvestigationInternalIncomingMessageSync/ENF_FRM_9074_SanctionAddResponseFormSync'
DECLARE @ServiceBehavior int = 33554464
DECLARE @InputSchemaAndMap nvarchar (500)=N'Customs.Inf.Enforcement.EAISchema.ENF_FRM_9074_SanctionAddResponseForm.xsd,Customs.Inf.Enforcement.EAISchema,   Version=2.0.0.2, Culture=neutral, PublicKeyToken=19fe7a7e7fda250c'
DECLARE @OutputSchemaAndMap nvarchar (500)=N'MalamTeam.Infrastructure.GeneralServices.EAISchema.INF_MSG_Generic.xsd,MalamTeam.Infrastructure.GeneralServices.EAISchema, Version=2.0.0.2, Culture=neutral, PublicKeyToken=3cd56da8249630bd'


--SELECT * FROM config.Address a
--WHERE a.AddressPath LIKE '%Enforcement%'

--Get From Dev
DECLARE @ServiceID uniqueidentifier =newid()
DECLARE @EndpointnetMsmqBindingID uniqueidentifier = newid()
DECLARE @EndpointwsHttpBindingID uniqueidentifier = newid()

DECLARE @EndpointMSMQ1ID uniqueidentifier = newid()
DECLARE @EndpointHTTP1ID uniqueidentifier = newid()

--SELECT *  
--FROM config.Address where AddressId IN ('114F1854-0557-E111-9D42-0050568F0023','7087A9C1-513F-E011-B677-005056894001','0538435A-011C-E111-8B19-0050568F0023')
-----------------------Service + Endpoint----------------------------

IF NOT EXISTS (SELECT TOP 1 1 FROM config.Service WHERE config.Service.ServiceName = @ServiceName)
INSERT INTO config.Service (ServiceId, ServiceNumber, ServiceName, ServiceBehavior, ModuleId, Description, CustomsVersion)
VALUES (@ServiceID, @ServiceNumber, @ServiceName, @ServiceBehavior, @ModuleId, @ServiceDescription, '2') 


IF NOT EXISTS (SELECT TOP 1 1 FROM config.Endpoint WHERE config.Endpoint.Action = @EndpointMSMQ1)
INSERT INTO config.Endpoint ( EndpointId, AddressId, BindingType, Action, DeliveryAgent,ConfigurationName)
VALUES (@EndpointnetMsmqBindingID, @ServiceAddressIdMSMQ1, 'netMsmqBinding', @EndpointMSMQ1, 'MSMQ1','MsmqRequestToProvider')

IF NOT EXISTS (SELECT TOP 1 1 FROM config.Endpoint WHERE config.Endpoint.Action = @EndpointHTTP1)
INSERT INTO config.Endpoint (EndpointId, AddressId, BindingType, Action, DeliveryAgent,ConfigurationName)
VALUES (@EndpointwsHttpBindingID, @ServiceAddressIdHTTP1, 'wsHttpBinding', @EndpointHTTP1, 'HTTP1','RequestTo2WayProvider')


-----------------------ServiceEndpoint----------------------------




IF NOT EXISTS (SELECT TOP 1 1 FROM config.ServiceEndpoint WHERE config.ServiceEndpoint.ServiceId = @ServiceID AND config.ServiceEndpoint.EndpointId = @EndpointnetMsmqBindingID)
INSERT INTO config.ServiceEndpoint (Id, ServiceId, EndpointId, Direction, IsAsyncEndpoint)
VALUES (@EndpointMSMQ1ID ,@ServiceID, @EndpointnetMsmqBindingID, '1', '1')  --net

IF NOT EXISTS (SELECT TOP 1 1 FROM config.ServiceEndpoint WHERE config.ServiceEndpoint.ServiceId = @ServiceID AND config.ServiceEndpoint.EndpointId = @EndpointwsHttpBindingID)
INSERT INTO config.ServiceEndpoint (Id ,ServiceId, EndpointId, Direction, IsAsyncEndpoint)
VALUES (@EndpointHTTP1ID ,@ServiceID, @EndpointwsHttpBindingID, '1', '0')  --http

-----------------------SchemaAndMap---------------------------------------

IF NOT EXISTS (SELECT TOP 1 1 FROM config.SchemaAndMap WHERE config.SchemaAndMap.ServiceId = @ServiceID AND config.SchemaAndMap.MessageRole = 1)
INSERT INTO config.SchemaAndMap (ServiceId, MessageRole, InputSchema, ValidateInput, ValidateOutput)
VALUES ( @ServiceID, '1',@InputSchemaAndMap,1, 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM config.SchemaAndMap WHERE config.SchemaAndMap.ServiceId = @ServiceID AND config.SchemaAndMap.MessageRole = 2)
INSERT INTO config.SchemaAndMap (ServiceId, MessageRole, OutputSchema, ValidateInput, ValidateOutput)
VALUES ( @ServiceID, '2', @OutputSchemaAndMap, 0,1)

-----------------------ProfileService---------------------------------------

IF NOT EXISTS (SELECT TOP 1 1 FROM config.ProfileService WHERE config.ProfileService.ServiceId = @ServiceID )
INSERT INTO config.ProfileService (ProfileId, ServiceId)
VALUES ('815E1B11-8DB6-E011-817E-0050568F0023', @ServiceID)-- מלבד סרויס ID לא לגעת

-----------------------ServiceStatistics---------------------------------------

IF NOT EXISTS (SELECT TOP 1 1 FROM config.ServiceStatistics WHERE config.ServiceStatistics.ServiceId = @ServiceID )
INSERT INTO config.ServiceStatistics (ServiceId, SamplingPeriod, ProviderProcessingThreshold, InvocationFrequencyThreshold, DecisionOperatorId)-- מלבד סרויס ID לא לגעת
VALUES (@ServiceID, '120', '10000', '200', '1')






--SELECT * from config.Service
--WHERE ServiceName ='SaveCE_FRM_15_getConditionalExemptionLocalAndFuelPurchaseReportDetails'


--UPDATE config.Service
--SET ServiceName = 'SaveCE_FRM_15_getConditionalExemptionPurchaseReportDetails'
--WHERE ServiceId = '51E154B6-9DAF-4C6F-B705-2C0C394FD416'



--DECLARE @EndpointMSMQ1 nvarchar(225)= N'http://tempuri.org/IConditionalIncomingMessagesContract/SaveCE_FRM_15_getConditionalExemptionConditionalExemptionLocalAndFuelPurchaseReportDetails'
--DECLARE @EndpointHTTP1 nvarchar(225)= N'http://tempuri.org/IConditionalIncomingMessagesContractSync/SaveCE_FRM_15_getConditionalExemptionConditionalExemptionLocalAndFuelPurchaseReportDetailsSync'


--SELECT * FROM config.Endpoint
--WHERE Action LIKE 'http://tempuri.org/IConditionalIncomingMessagesContract/SaveCE_FRM_15_getConditionalExemptionConditionalExemptionLocalAndFuelPurchaseReportDetails'

--SELECT * FROM config.Endpoint
--WHERE Action LIKE 'http://tempuri.org/IConditionalIncomingMessagesContractSync/SaveCE_FRM_15_getConditionalExemptionConditionalExemptionLocalAndFuelPurchaseReportDetailsSync'


--UPDATE  config.Endpoint
--set Action = 'http://tempuri.org/IConditionalIncomingMessagesContract/SaveCE_FRM_15_getConditionalExemptionPurchaseReportDetails'
--WHERE Action LIKE 'http://tempuri.org/IConditionalIncomingMessagesContract/SaveCE_FRM_15_getConditionalExemptionLocalAndFuelPurchaseReportDetails'
--AND Endpointid = '2A791CD2-DF89-42C0-9B62-2EEDA485D486'


--UPDATE  config.Endpoint
--set Action = 'http://tempuri.org/IConditionalIncomingMessagesContractSync/SaveCE_FRM_15_getConditionalExemptionPurchaseReportDetailsSync'
--WHERE Action = 'http://tempuri.org/IConditionalIncomingMessagesContractSync/SaveCE_FRM_15_getConditionalExemptionLocalAndFuelPurchaseReportDetailsSync'
--AND Endpointid = 'C22D9BA1-CED8-4373-9F63-0AF438DCE8A2'
