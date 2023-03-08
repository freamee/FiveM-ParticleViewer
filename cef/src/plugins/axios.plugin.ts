import axios from "axios";

// @ts-ignore
const resourceName = typeof GetParentResourceName === "function" ? GetParentResourceName() : "unknown_resource";

export const AxiosInstance = axios.create({
    baseURL: `https://${resourceName}/`
})