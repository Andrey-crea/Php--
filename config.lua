-- Recovered code config.lu + fix after decompilation
-- Lua 5.1.5
-- Day R Survival v694

-- Конфиг приложения (Corona SDK)
(function(...)
    local is_debug = false -- по ASM: LOADBOOL R0 0 0, выбирает лицензионный ключ
    application = {
        content = {
            width = 640,
            height = 960,
            scale = 'letterbox',
            fps = 30,
            imageSuffix = {['@2x'] = 2, ['@4x'] = 4},
            shaderPrecision = 'highp'
        },
        notification = {iphone = {types = {'badge', 'sound', 'alert'}}},
        -- Лицензия Google Play (публичный ключ RSA)
        license = {
            google = {
                key = is_debug
                    and 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo3BXXdWHnw1QSWySjrlEYMEKttcD0Zy1D40OfcMiLsq1F6xQv9HPW65J/9KBLb9ot1/zq/VNpuGpRN6Ynh/9GexL47osD+fObyhDsTVQEzBj+S+0d6wEORqA4czWoB4CTjoAAhcCDi+P7jqtgG7O1395nhhakOLfgncrIAIDR3TXwavcODinwztj9KP2I3lilNuGBCDx99w5uOaHGKT5cFHniroasxibqohbv1Ru69ppYEggpeHy2VzR1GfhTfT4xaKG+8vwc3UdBj/PDVO065KE7rR2oJ2/wpDtjUHtvUh46OkMzPm0Hwi6AdKYIbOaMEdO6MIVa/19AeQiOIvROwIDAQAB'
                    or 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjoQGvO4+JtrjC0Ek/qplSF/2nsmveQUj6RlW0b3/Mq/LvGDPVc7A3+2x1y90JT5xv6yvYireVF6pkBbaVzGmR87v9rzFdYGbDIlq0ew0l5HE+IZxZMfIKtGLmWjoayk4u0+6xMrw4iDAue9RmgCG0YmXXt63MYPZtKzP3x15I8nvadVA/HPcuiNeW/xaeJsHJuR5puDdfzHZHuLc2mRJtUfGnrJlhz+oWrU3hCK9Kki6nxLk+P9YgK5TWM6BCTGwIn1N1SXfqmGCbiTsXR2rY1TzB2lA4zA4iYjoQmwrA87k1HAP4GP8uMYij3YgZFn/KAEPuuurqnFTP2wPEi/xRQIDAQAB',
                policy = 'strict'
            }
        }
    }
end)()

-- Метаданные сборки (добавляются сборщиком Corona)
;(function(...)
    if not application or type(application) ~= 'table' then
        application = {}
    end
    application.metadata = {
        appName = 'Day R Survival',
        appVersion = '1.694',
        appPackageId = 'com.gm_shaber.dayr',
        mode = 'release',
        build = '2021.3658',
        coronaBuild = '2021.3658'
    }
end)()
