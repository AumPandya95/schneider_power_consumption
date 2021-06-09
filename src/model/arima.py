from typing import Union

import numpy as np
import statsmodels.api as sm


class ImplementArimaModel:
    """
    Arima model implementation along with validations.
    """

    def __init__(
            self,
            time_series: Union[np.array, list],
            validate: bool = True,
            optimise_model: bool = False
    ) -> None:
        self.time_series = time_series
        self.validate = validate
        self.optimise_model = optimise_model

    def train_model(
            self,
            series: Union[np.array, list],
            order: tuple,
            seasonal_order: tuple,
            validate_model: bool = True,
            validation_metric: str = 'MSE'
    ):
        """
        Train the arima model using the order and seasonal order hyper-parameters.
        :param series: The time series on which model has to be trained
        :param order: The auto-regressive, integrated and the moving average component of the model
        :param seasonal_order: The seasonal auto-regressive, integrated and the moving average component of the model
        :param validate_model: If True, a metric of choice is calculated for the model
        :param validation_metric: ['MSE', 'RMSE', 'MAPE'] If validate_model=True, then provide a choice for the desired
        metric
        :return: The trained model and validation results
        """
        model = sm.tsa.arima.ARIMA(endog=series,
                                   order=order,
                                   seasonal_order=seasonal_order).fit()

        return None
