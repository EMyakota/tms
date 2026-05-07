project_id = object.project.project_ext_id
target_id = '73a03a97-6620-4687-81b8-9310742a6311'
#project_id = 479905
# Получаем данные процесса и статуса проекта из NRI.
status, resp_data = get_nri("getBsData", idList=project_id)

# Получаем данные виз и комментариев по согласованию ОТР из NRI.
status_visa, visa_data = get_nri("/moreInfo/getVisaComments", projectId =project_id)

if status != 200:
    raise error("Невозможно получить данные проекта из NRI.\n"
                f"Код ошибки - {status}"\n"
                f"Данные ответа - {resp_data}")
if status_visa != 200:
    raise error("Невозможно получить данные виз и комментариев из NRI.\n"
                f"Код ошибки - {status}")

for item in visa_data:
    vised_data = item['vised']
    for item_vised in vised_data:
        user_nri = item_vised.get('fullName')
        if item_vised.get('isAgree') == True:
            type_vised = 'Согласовано'
        else:
            type_vised = 'Отклонено' 
        comment_nri = item_vised.get('comment')
        comment = "NRI\n"+"Визирующий: "+user_nri+"\n"+"Виза: "+type_vised+"\n"+comment_nri
        external_code = item_vised.get('visaId')
        cs = object.documentcomments_set.filter(deleted_at__isnull=True,external_code=external_code,target_id = target_id)
        if not cs.exists():
            messages.append(f"Получен новый комментарий из NRI c id {external_code}")
            object.add_comment (comment = comment,
                                email = 'tech_nri4dmc_ms@beeline.ru',
                                external_code = external_code,
                                target_id = target_id)
                                
# Если 200, обрабатываем ответ.
resp_data = resp_data[0]
wfStepDef = resp_data["comProject"]["wfCurrentStep"]["wfStepDef"]
processdefid = wfStepDef["processDefId"]
status_code = wfStepDef["code"]
status_name = wfStepDef["name"]
if status_code in [
    'position_search',
    'nr_vising',
    'NR_vised',
    'position_consideration',
    'pos_select_vising',
    'id_preparation',
    'id_vising',
    'id_vised',
    'AFU_preparation',
    'PPD_preparation']:
    result = False
    
elif status_code in ['AFU_vising']:
    result = False
    stage.set_variable("result", result)
    for item in visa_data:
        if item.get('stepName') == 'AFU_vising' and item.get('notVised') == []:
            messages.append("AFU - Есть все визы")
            vised_data = item['vised']
            for item_vised in vised_data:
                if item_vised.get('isAgree') == False:
                    messages.append("AFU - Есть отрицательная виза. Запущен возврат на Подготовку ОТР в NRI")
                    #Установка статуса проекта в NRI "Подготовка ОТР"
                    #Автовозврат при отрицательной визе
                    path = "setStep"
                    status_step, step_data = get_nri(path, projectId=object.project.project_ext_id, stepCode="AFU_preparation")
                    if status_step == 200:
                        resp_type = step_data.get("type")
                        if not resp_type:
                            raise error(f"Отстутствует поле `type` в ответе API NRI `{path}`")
                        if resp_type == "DMC_ERROR":
                            errors = step_data.get("errors")
                            err_msg = "\n".join(errors) if errors else "Произошла неизвестная ошибка"
                            raise error(f"Ошибки при возврате на подготовку ОТР в NRI: \n {err_msg}")
                        #Установим в головном процессе, что проведен автовозврат
                        ps = object.project.processes_set.filter(deleted_at__isnull=True,type=1,type_object=3,object_id=object.id)
                        for item_process in ps:
                            item_process.set_variable("is_auto_return", True)
                    else:
                        raise error(f"Получен ответ от API NRI `{path}` со статусом {status_step}")
                    exit()
elif status_code in ['PPD_vising']:
    result = False
    stage.set_variable("result", result)
    for item in visa_data:
        if item.get('stepName') == 'PPD_vising' and item.get('notVised') == []:
            messages.append("PPD - Есть все визы")
            vised_data = item['vised']
            for item_vised in vised_data:
                if item_vised.get('isAgree') == False:
                    messages.append("PPD - Есть отрицательная виза. Запущен возврат на Подготовку ОТР в NRI")
                    #Установка статуса проекта в NRI "Подготовка ОТР"
                    #Автовозврат при отрицательной визе
                    path = "setStep"
                    status_step, step_data = get_nri(path, projectId=object.project.project_ext_id, stepCode="AFU_preparation")
                    if status_step == 200:
                        resp_type = step_data.get("type")
                        if not resp_type:
                            raise error(f"Отстутствует поле `type` в ответе API NRI `{path}`")
                        if resp_type == "DMC_ERROR":
                            errors = step_data.get("errors")
                            err_msg = "\n".join(errors) if errors else "Произошла неизвестная ошибка"
                            raise error(f"Ошибки при возврате на подготовку ОТР в NRI: \n {err_msg}")
                        #Установим в головном процессе, что проведен автовозврат
                        ps = object.project.processes_set.filter(deleted_at__isnull=True,type=1,type_object=3,object_id=object.id)
                        for item_process in ps:
                            item_process.set_variable("is_auto_return", True)
                    else:
                        raise error(f"Получен ответ от API NRI `{path}` со статусом {status_step}")
                    exit()
elif ((status_code in ['PPD_vised'] and processdefid in [1, 24])
      or (status_code in ['AFU_vised'] and processdefid in [46, 47])):
    result = True
elif (status_code in ['AFU_vised'] and processdefid in [1, 24]):
    result = False
elif status_code in [
    'SMR_input_data',
    'tech_acceptance',
    'finance_acceptance',
    'commerce_acceptance',
    'BS_delivery',
    'project_completed',
    'project_canceled']:
    result = True
else:
    raise error("Обратитесь в техническую поддержку.\n"
         "Не корректный статус или код процесса проекта в NRI.\n"
         f"Статус проекта в NRI - {status_name}.\n"
         f"Код процесса в NRI - {processdefid}.")
stage.set_variable("result", result)