class SalarySlipMailer < ApplicationMailer
  def deliver_slip
    @salary = params[:salary]
    @employee = params[:employee]
    @personal_detail = params[:personal_detail]

    mail(
      to: params[:user].email,
      subject: "Your Salary Slip for #{@salary.batch.period_label}"
    )
  end
end
