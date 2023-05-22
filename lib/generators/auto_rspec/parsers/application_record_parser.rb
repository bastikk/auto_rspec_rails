# frozen_string_literal: true

RSpec.describe Services::SocialHistory::UpdatePatientEmrCategory do
  subject { described_class.call(category, params) }

  let(:freetext_detail_definition) { build(:millennium_sh_definition_detail) }
  let(:numeric_detail_definition) { build(:millennium_sh_definition_detail, :numeric) }
  let(:alpha_detail_definition) do
    build(:millennium_sh_definition_detail, :alpha, allow_other_text: true, multi_select_ind: true)
  end
  let(:alpha_responses) { alpha_detail_definition[:alpha_response] }
  let(:fuzzyage_detail_definition) { build(:millennium_sh_definition_detail, :fuzzyage) }
  let(:category_definition) do
    build(
      :millennium_sh_definition,
      detail_elements: [
        freetext_detail_definition,
        numeric_detail_definition,
        alpha_detail_definition,
        fuzzyage_detail_definition
      ]
    )
  end
  let(:sh_definition) { build(:sh_definition, definition: [category_definition]) }
  let(:category) { create(:patient_emr_sh_category, sh_definition: sh_definition) }
  let(:answer) do
    create(
      :patient_emr_sh_detail,
      :with_freetext,
      patient_emr_sh_category: category,
      sh_definition: sh_definition,
      category_definition: category_definition,
      detail_definition: freetext_detail_definition
    )
  end
  let(:new_comments) { 'new comments' }
  let(:new_free_text) { 'new free text' }
  let(:answer_params) { [] }
  let(:params) { { status: status, comments: new_comments, answers: answer_params } }

  context 'when status nil' do
    let(:status) { nil }

    it 'returns error' do
      expect(subject).to be_failure
      expect(subject.errors).to eq(['Not valid params'])
      expect(category.patient_emr_update.errors[:action]).to eq(["can't be blank"])
    end
  end

  context 'when status UPDATE' do
    let(:status) { 'UPDATE' }

    context 'when emr has no updated before' do
      it 'creates patient_emr_update record' do
        expect { subject }.to change { category.patient_emr_update }.from(nil).to(PatientEmrShCategoryUpdate)
      end

      it 'saves changes to patient_emr_update and keeps emr record as it was' do
        expect { subject }.not_to(change { category.reload.comments })
        expect(category.patient_emr_update.comments).to eq(new_comments)
      end

      context 'when category has answers' do
        before { category.answers << answer }

        context 'when params has no answer params' do
          before { params.delete(:answers) }

          it 'copies answers to patient_emr_update' do
            subject
            expect(category.patient_emr_update.answers.size).to eq(1)

            answer = category.patient_emr_update.answers.first
            expect(answer.task_assay_cd).to eq(freetext_detail_definition[:task_assay_cd])
            expect(answer.free_text).to eq(answer.free_text)
            expect(answer.prompt).to eq(freetext_detail_definition[:description])
            expect(answer.field_type).to eq(freetext_detail_definition[:field_type])
          end
        end

        context 'when params has answer params' do
          let(:answer_params) { [] }

          it 'does not copy answers to patient_emr_update' do
            subject
            expect(category.patient_emr_update.answers.size).to eq(0)
          end
        end
      end

      context 'when answer_params present' do
        let(:params) do
          {
            status: status,
            answers: [
              { task_assay_cd: freetext_detail_definition[:task_assay_cd], free_text: new_free_text }
            ]
          }
        end

        it 'saves changes to patient_emr_update and keeps emr record as it was' do
          subject
          expect(category.answers).to eq([])
          expect(category.patient_emr_update.comments).to eq(category.comments)

          expect(category.patient_emr_update.answers.size).to eq(1)

          answer = category.patient_emr_update.answers.first
          expect(answer.task_assay_cd).to eq(freetext_detail_definition[:task_assay_cd])
          expect(answer.free_text).to eq(new_free_text)
          expect(answer.prompt).to eq(freetext_detail_definition[:description])
          expect(answer.field_type).to eq(freetext_detail_definition[:field_type])
        end
      end

      context 'when params are invalid' do
        let(:long_string) { '1' * 3001 }
        let(:params) do
          {
            status: status,
            comments: long_string,
            answers: [
              { task_assay_cd: freetext_detail_definition[:task_assay_cd], free_text: '' },
              { task_assay_cd: numeric_detail_definition[:task_assay_cd], value: '' },
              { task_assay_cd: fuzzyage_detail_definition[:task_assay_cd], value: '' },
              { task_assay_cd: alpha_detail_definition[:task_assay_cd], selected: [] },
              { task_assay_cd: 'invalid' }
            ]
          }
        end

        it 'returns error' do
          expect(subject).to be_failure
          expect(subject.errors).to eq(['Not valid params'])
          expect(category.patient_emr_update.errors[:comments]).to eq(['is too long (maximum is 2000 characters)'])
          expect(category.patient_emr_update.errors[:'answers[0].free_text']).to eq(["can't be blank"])
          expect(category.patient_emr_update.errors[:'answers[1].value']).to eq(["can't be blank"])
          expect(category.patient_emr_update.errors[:'answers[2].value']).to eq(["can't be blank"])
          expect(category.patient_emr_update.errors[:'answers[3].selected']).to(
            eq ['must have at least one selected option if no free text is present']
          )
          expect(category.patient_emr_update.errors[:'answers[4].definition']).to(
            eq ['could not be found for taskAssayCd=invalid']
          )
        end
      end
    end

    context 'when emr has updated before' do
      let(:patient_emr_update) do
        create(
          :patient_emr_sh_category_update,
          patient_emr_sh_category: category
        )
      end

      it 'updates patient_emr_update record' do
        expect { subject }.to(
          change { patient_emr_update.reload.comments }.from(patient_emr_update.comments).to(new_comments)
        )
      end

      context 'when params has answer params' do
        let(:answer_params) do
          [
            { task_assay_cd: freetext_detail_definition[:task_assay_cd], free_text: new_free_text },
            { task_assay_cd: numeric_detail_definition[:task_assay_cd], value: '1' }
          ]
        end

        it 'saves changes to patient_emr_update and keeps emr record as it was' do
          expect { subject }.not_to(change { category.reload })

          expect(category.patient_emr_update.comments).to eq(new_comments)
          expect(category.patient_emr_update.answers.size).to eq(2)

          answer = category.patient_emr_update.answers.FREETEXT.first
          expect(answer.task_assay_cd).to eq(freetext_detail_definition[:task_assay_cd])
          expect(answer.free_text).to eq(new_free_text)
          expect(answer.prompt).to eq(freetext_detail_definition[:description])
          expect(answer.field_type).to eq(freetext_detail_definition[:field_type])

          answer = category.patient_emr_update.answers.NUMERIC.first
          expect(answer.task_assay_cd).to eq(numeric_detail_definition[:task_assay_cd])
          expect(answer.value).to eq('1')
          expect(answer.prompt).to eq(numeric_detail_definition[:description])
          expect(answer.field_type).to eq(numeric_detail_definition[:field_type])
        end
      end

      context 'when params are invalid' do
        let(:long_string) { '1' * 3001 }
        let(:params) do
          {
            status: status,
            comments: long_string,
            answers: [
              { task_assay_cd: freetext_detail_definition[:task_assay_cd], free_text: '' },
              { task_assay_cd: numeric_detail_definition[:task_assay_cd], value: '' },
              { task_assay_cd: fuzzyage_detail_definition[:task_assay_cd], value: '' },
              { task_assay_cd: alpha_detail_definition[:task_assay_cd], selected: [] },
              { task_assay_cd: 'invalid' }
            ]
          }
        end

        it 'returns error' do
          expect(subject).to be_failure
          expect(subject.errors).to eq(['Not valid params'])
          expect(category.patient_emr_update.errors[:comments]).to eq(['is too long (maximum is 2000 characters)'])
          expect(category.patient_emr_update.errors[:'answers[0].free_text']).to eq(["can't be blank"])
          expect(category.patient_emr_update.errors[:'answers[1].value']).to eq(["can't be blank"])
          expect(category.patient_emr_update.errors[:'answers[2].value']).to eq(["can't be blank"])
          expect(category.patient_emr_update.errors[:'answers[3].selected']).to(
            eq ['must have at least one selected option if no free text is present']
          )
          expect(category.patient_emr_update.errors[:'answers[4].definition']).to(
            eq ['could not be found for taskAssayCd=invalid']
          )
        end
      end
    end
  end
end